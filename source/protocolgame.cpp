////////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////
#include "otpch.h"
#include <boost/function.hpp>
#include <iostream>
#include <iomanip>

#include "protocolgame.h"
#include "textlogger.h"

#include "waitlist.h"
#include "player.h"

#include "connection.h"
#include "networkmessage.h"
#include "outputmessage.h"

#include "iologindata.h"
#include "ioban.h"

#include "items.h"
#include "tile.h"
#include "house.h"

#include "actions.h"
#include "creatureevent.h"
#include "quests.h"

#include "chat.h"
#include "configmanager.h"
#include "game.h"

#include "resources.h"
#include "spectators.h"

#if defined(WINDOWS) && !defined(_CONSOLE)
#include "gui.h"
#endif

extern Game g_game;
extern ConfigManager g_config;
extern Actions actions;
extern CreatureEvents* g_creatureEvents;
extern Chat g_chat;

template<class FunctionType>
void ProtocolGame::addGameTaskInternal(uint32_t delay, const FunctionType& func)
{
	if(delay > 0)
		Dispatcher::getInstance().addTask(createTask(delay, func));
	else
		Dispatcher::getInstance().addTask(createTask(func));
}

#ifdef __ENABLE_SERVER_DIAGNOSTIC__
uint32_t ProtocolGame::protocolGameCount = 0;

#endif
void ProtocolGame::setPlayer(Player* p)
{
	player = p;
}

void ProtocolGame::release()
{
	if(player && player->client) {
		if(!m_spectator) {
			if(player->client->getOwner() == shared_from_this())
				player->client->resetOwner();
		}
		else if(player->client->isBroadcasting())
			player->client->removeSpectator(this);

		player->unRef();
		player = nullptr;
	}

	OutputMessagePool::getInstance().removeProtocolFromAutosend(shared_from_this());
	Protocol::release();
}

void ProtocolGame::spectate(const std::string& name, const std::string& password, uint16_t version)
{
	PlayerVector players = g_game.getPlayersByName(name);
	Player* _player = NULL;	

	if(!players.empty())
		_player = players[random_range(0, (players.size() - 1))];

	if(!_player || _player->isRemoved() || !_player->client->isBroadcasting() || !_player->client->getOwner())
	{
		disconnectClient(0x14, "Stream unavailable.");
		return;
	}

	if(_player->client->banned(getIP()))
	{
		disconnectClient(0x14, "You are banned from this stream.");
		return;
	}

	if(!_player->client->check(password))
	{
		disconnectClient(0x14, "This stream is protected! Invalid password.");
		return;
	}

	if(_player->getClientVersion() > version){
		disconnectClient(0x14, "This stream requires the use of a custom client!\nDownload in: newtibia.com");
		return;
	}


	m_spectator = true;
	player = _player;
	player->addRef();

	
	player->sendCreatureAppear(player, this);
	player->sendContainers(this);
	if(PrivateChatChannel* channel = g_chat.getPrivateChannel(player))
		chat(channel->getId());

	player->client->addSpectator(this);
	Dispatcher::getInstance().addTask(
						createTask(boost::bind(&ProtocolGame::sendMagicEffect, this, player->getPosition(), MAGIC_EFFECT_TELEPORT)));

	//player->sendCreatureSay(player, MSG_PRIVATE, "You are exhausted.", NULL, 0);
	//Dispatcher::getInstance().addTask(createTask(boost::bind(&ProtocolGame::sendCreatureSay, player, MSG_PRIVATE, "You are exhausted.", NULL, 0)));

	/*
	uint32_t version = (player->client ? player->getClientVersion() : 860); //pega do jogador

	
	if (version <= 860)
		sendFYIBox("teste1");
	else if (version > 860)
		sendFYIBox("teste2");*/
	

	

	acceptPackets = true;
	OutputMessagePool::getInstance().addProtocolToAutosend(shared_from_this());
}

void ProtocolGame::spectatorTurn(uint8_t direction) {
	PlayerVector players;
	for(AutoList<Player>::iterator it = Player::autoList.begin(); it != Player::autoList.end(); ++it) {
		if (!it->second->client->isBroadcasting()) {
			continue;
		}

		if (it->second->client->getPassword() != "") {
			continue;
		}

		if(it->second->client->banned(getIP())) {
			continue;
		}

		players.emplace_back(it->second);
	}

	uint32_t castPosition = 0;
	for (const auto& it : players) {
		if (it == player) {
			break;
		}
		castPosition++;
	}


	bool limitReached = false;
	std::string message;
	const size_t& size = players.size() - 1;

	if (players.size() <= 1) {
		message = "Only this cast is active.";
	} else {
		switch(direction) {
			case 0:
				if (castPosition == 0) {
					message = "You are already in the first cast, use CTRL + \\/";
					limitReached = true;
				} else {
					castPosition = 0;
				}
				break;
			case 1:
				if (castPosition >=size) {
					message = "No casts more found, use CTRL + <<";
					limitReached = true;
				} else {
					castPosition++;
				}
				break;
			case 2:
				if (castPosition >= size) {
					message = "You are already in the last cast, use CTRL + /\\";
				} else {
					castPosition = size;
				}
				break;
			case 3:
				if (castPosition == 0) {
					message = "No casts more found, use CTRL + >>";
					limitReached = true;
				} else {
					castPosition--;
				}
				break;
			default:
				break;
		}
	}

	if (limitReached) {
		sendCreatureSay(player, MSG_PRIVATE, message, NULL, 0);
		return;
	}

	if (castPosition > size) {
		castPosition = 0;
	}

	Player* foundPlayer = players[castPosition];
	if (!foundPlayer || foundPlayer == player) {
		return;
	}


	const time_t& now = time(nullptr);
	if((now - this->m_lastSwitch) < 1) {
		return;
	}

	this->m_lastSwitch = now;
    player->client->removeSpectator(this);
	player->unRef();

	player = foundPlayer;
	player->addRef();

	knownCreatureSet.clear();
	player->sendCreatureAppear(player, this);
	player->sendContainers(this);
	if(PrivateChatChannel* channel = g_chat.getPrivateChannel(player)) {
		chat(channel->getId());
	}

	player->client->addSpectator(this);
	sendMagicEffect(player->getPosition(), MAGIC_EFFECT_TELEPORT);

/*	std::vector<Player*> candidates;
	int index = 0;

	for(AutoList<Player>::iterator it = Player::autoList.begin(); it != Player::autoList.end(); ++it) {
		if (!it->second->client->isBroadcasting()) {
			continue;
		}

		if (it->second->client->getPassword() != "") {
			continue;
		}

		if(it->second->client->banned(getIP())) {
			continue;
		}
		
		if (it->second == player) {
			index = candidates.size();
		}

		candidates.push_back(it->second);
	}

	if (candidates.size() < 2) {
		return;
	}

	if (direction == 0 || direction == 1) {
		direction = uint8_t (1);

	}

	if (direction == 2 || direction == 3) {
		direction = uint8_t (-1);
	}
	
	if (index == 0 && direction == -1) {
		direction = uint8_t (0);
	}
	
    Player* _player = candidates[(index + direction) % candidates.size()];
    if (!_player || player == _player) {
        return;
    }

	if(!_player || _player->isRemoved() || !_player->client->getOwner()) {
		return;
	}
	
	if((time(NULL) - this->m_lastSwitch) < 1) {
		return;
	}

	this->m_lastSwitch = time(NULL);
    player->client->removeSpectator(this);
	player->unRef();

	player = _player;
	player->addRef();

	knownCreatureSet.clear();
	player->sendCreatureAppear(player, this);
	player->sendContainers(this);
	if(PrivateChatChannel* channel = g_chat.getPrivateChannel(player))
		chat(channel->getId());

	player->client->addSpectator(this);

	Dispatcher::getInstance().addTask(
						createTask(boost::bind(&ProtocolGame::sendMagicEffect, this, player->getPosition(), MAGIC_EFFECT_TELEPORT)));
	
	//acceptPackets = true;
	*/
}

void ProtocolGame::login(const std::string& name, uint32_t id, const std::string&,
	OperatingSystem_t operatingSystem, uint16_t version, bool gamemaster)
{
	//dispatcher thread
	PlayerVector players = g_game.getPlayersByName(name);
	Player* foundPlayer = NULL;
	if(!players.empty())
		foundPlayer = players[random_range(0, (players.size() - 1))];

	bool accountManager = g_config.getBool(ConfigManager::ACCOUNT_MANAGER);
	if(!foundPlayer || g_config.getNumber(ConfigManager::ALLOW_CLONES) ||
		(accountManager && name == "Account Manager"))
	{
		player = new Player(name, getThis());
		player->addRef();

		player->setID();
		if(!IOLoginData::getInstance()->loadPlayer(player, name, true))
		{
			disconnectClient(0x14, "Your character could not be loaded.");
			return;
		}

		Ban ban;
		ban.value = player->getGUID();
		ban.param = PLAYERBAN_BANISHMENT;

		ban.type = BAN_PLAYER;
		if(IOBan::getInstance()->getData(ban) && !player->hasFlag(PlayerFlag_CannotBeBanned))
		{
			bool deletion = ban.expires < 0;
			std::string name_ = "Automatic ";
			if(!ban.adminId)
				name_ += (deletion ? "deletion" : "banishment");
			else
				IOLoginData::getInstance()->getNameByGuid(ban.adminId, name_, true);

			std::stringstream stream;
			stream << "Your account has been " << (deletion ? "deleted" : "banished") << " at:\n" << formatDateEx(ban.added, "%d %b %Y").c_str() << " by: " << name_.c_str()
				<< "\nReason:\n" << getReason(ban.reason).c_str() << ".\nComment:\n" << ban.comment.c_str() << ".\nYour " << (deletion ? "account won't be undeleted" : "banishment will be lifted at:\n")
				<< (deletion ? "" : formatDateEx(ban.expires).c_str());
			disconnectClient(0x14, stream.str().c_str());
			return;
		}

		if(IOBan::getInstance()->isPlayerBanished(player->getGUID(), PLAYERBAN_LOCK) && id != 1)
		{
			if(g_config.getBool(ConfigManager::NAMELOCK_MANAGER))
			{
				player->name = "Account Manager";
				player->accountManager = MANAGER_NAMELOCK;

				player->managerNumber = id;
				player->managerString2 = name;
			}
			else
			{
				disconnectClient(0x14, "Your character has been namelocked.");
				return;
			}
		}
		else if(player->getName() == "Account Manager")
		{
			if(!g_config.getBool(ConfigManager::ACCOUNT_MANAGER))
			{
				disconnectClient(0x14, "Account Manager is disabled.");
				return;
			}

			if(id != 1)
			{
				player->accountManager = MANAGER_ACCOUNT;
				player->managerNumber = id;
			}
			else
				player->accountManager = MANAGER_NEW;
		}

		if(gamemaster && !player->hasCustomFlag(PlayerCustomFlag_GamemasterPrivileges))
		{
			disconnectClient(0x14, "You are not a gamemaster! Turn off the gamemaster mode in your IP changer.");
			return;
		}

		if(!player->hasFlag(PlayerFlag_CanAlwaysLogin))
		{
			if(g_game.getGameState() == GAMESTATE_CLOSING)
			{
				disconnectClient(0x14, "Gameworld is just going down, please come back later.");
				return;
			}

			if(g_game.getGameState() == GAMESTATE_CLOSED)
			{
				disconnectClient(0x14, "Gameworld is currently closed, please come back later.");
				return;
			}
		}

		if(g_config.getBool(ConfigManager::ONE_PLAYER_ON_ACCOUNT) && !player->isAccountManager()/* &&
			!IOLoginData::getInstance()->hasCustomFlag(id, PlayerCustomFlag_CanLoginMultipleCharacters)*/)
		{
			bool found = false;
			PlayerVector tmp = g_game.getPlayersByAccount(id);
			for(PlayerVector::iterator it = tmp.begin(); it != tmp.end(); ++it)
			{
				if((*it)->getName() != name)
					continue;

				found = true;
				break;
			}

			if(tmp.size() > 0 && !found)
			{
				disconnectClient(0x14, "You may only login with one character\nof your account at the same time.");
				return;
			}
		}

		if(!WaitingList::getInstance()->login(player))
		{
			auto output = OutputMessagePool::getOutputMessage();

			std::stringstream ss;
			ss << "Too many players online.\n" << "You are ";

			int32_t slot = WaitingList::getInstance()->getSlot(player);
			if(slot)
			{
				ss << "at ";
				if(slot > 0)
					ss << slot;
				else
					ss << "unknown";

				ss << " place on the waiting list.";
			}
			else
				ss << "awaiting connection...";

			output->addByte(0x16);
			output->addString(ss.str());
			output->addByte(WaitingList::getTime(slot));
			send(output);
			disconnect();
			return;
		}

		if(!IOLoginData::getInstance()->loadPlayer(player, name))
		{
			disconnectClient(0x14, "Your character could not be loaded.");
			return;
		}

		player->setClientVersion(version);
		player->setOperatingSystem(operatingSystem);

		if(player->isUsingOtclient())
		{
			player->registerCreatureEvent("ExtendedOpcode");
		}

		player->lastIP = player->getIP();
		player->lastLoad = OTSYS_TIME();
		player->lastLogin = std::max(time(NULL), player->lastLogin + 1);

		if(!g_game.placeCreature(player, player->getLoginPosition()) && !g_game.placeCreature(player, player->getMasterPosition(), false, true))
		{
			disconnectClient(0x14, "Temple position is wrong. Contact with the administration.");
			return;
		}

		acceptPackets = true;
	} else {
		/*if(eventConnect != 0 || !g_config.getBool(ConfigManager::REPLACE_KICK_ON_LOGIN))
		{
			// task has already been scheduled just bail out (should not be overriden)
			disconnectClient(0x14, "You are already logged in.");
			return;
		}*/

		if (foundPlayer->client) {
			foundPlayer->client->disconnect();
			foundPlayer->isConnecting = true;
			foundPlayer->setClientVersion(version);
			eventConnect = Scheduler::getInstance().addEvent(createSchedulerTask(
				1000, boost::bind(&ProtocolGame::connect, getThis(), foundPlayer->getID(), operatingSystem, version)));
		} else {
			connect(foundPlayer->getID(), operatingSystem, version);
		}
	}
	OutputMessagePool::getInstance().addProtocolToAutosend(shared_from_this());
}

bool ProtocolGame::logout(bool displayEffect, bool forceLogout)
{
	//dispatcher thread
	if(!player)
		return false;

	if(player->hasCondition(CONDITION_EXHAUST, 1))
	{
		player->sendTextMessage(MSG_STATUS_SMALL, "You have to wait a while.");
		return false;
	}

	if(!player->isRemoved())
	{
		if(!forceLogout)
		{
			if(!IOLoginData::getInstance()->hasCustomFlag(player->getAccount(), PlayerCustomFlag_CanLogoutAnytime))
			{
				if(player->getTile()->hasFlag(TILESTATE_NOLOGOUT))
				{
					if(Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_EXHAUST, 500, 0, false, 1))
						player->addCondition(condition);

					player->sendCancelMessage(RET_YOUCANNOTLOGOUTHERE);
					return false;
				}

				if(player->getZone() != ZONE_PROTECTION && player->hasCondition(CONDITION_INFIGHT))
				{
					if(Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_EXHAUST, 500, 0, false, 1))
						player->addCondition(condition);

					player->sendCancelMessage(RET_YOUMAYNOTLOGOUTDURINGAFIGHT);
					return false;
				}

				if(!g_creatureEvents->playerLogout(player, false)) //let the script handle the error message
					return false;
			}
			else
				g_creatureEvents->playerLogout(player, true);
		}
		else if(!g_creatureEvents->playerLogout(player, true))
			return false;

		if(displayEffect && !player->isGhost())
			g_game.addMagicEffect(player->getPosition(), MAGIC_EFFECT_POFF);
	}

	player->client->clear(true);
	disconnect();
	if(player->isRemoved())
		return true;

	return g_game.removeCreature(player);
}

void ProtocolGame::chat(uint16_t channelId)
{
	PrivateChatChannel* tmp = g_chat.getPrivateChannel(player);
	if(!tmp)
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	if(channelId)
	{
		msg->addByte(0xB2);
		msg->add<uint16_t>(tmp->getId());
		msg->addString(tmp->getName());
	}
	else
	{
		msg->addByte(0xAB);
		msg->addByte(1);
		msg->add<uint16_t>(tmp->getId());
		msg->addString("Live Channel");
	}
}

bool ProtocolGame::connect(uint32_t playerId, OperatingSystem_t operatingSystem, uint16_t version)
{
	eventConnect = 0;

	Player* _player = g_game.getPlayerByID(playerId);
	if(!_player || _player->isRemoved() || _player->hasClient())
	{
		disconnectClient(0x14, "You are already logged in.");
		return false;
	}

	if (isConnectionExpired()) {
		//ProtocolGame::release() has been called at this point and the Connection object
		//no longer exists, so we return to prevent leakage of the Player.
		return false;
	}

	player = _player;
	player->addRef();
	player->client->setOwner(getThis());
	player->isConnecting = false;

	player->sendCreatureAppear(player, this);
	player->setOperatingSystem(operatingSystem);
	player->setClientVersion(version);

	player->lastIP = player->getIP();
	player->lastLoad = OTSYS_TIME();

	g_chat.reOpenChannels(player);
	acceptPackets = true;
	return true;
}

void ProtocolGame::disconnectClient(uint8_t error, const char* message)
{
	auto output = OutputMessagePool::getOutputMessage();
	output->addByte(error);
	output->addString(message);
	send(output);
	disconnect();
}

void ProtocolGame::onConnect()
{
	auto output = OutputMessagePool::getOutputMessage();

	// Skip checksum
	output->skipBytes(sizeof(uint32_t));

	output->add<uint16_t>(0x0006);
	output->addByte(0x1F);
	output->add<uint16_t>(random_range(0, 0xFFFF));
	output->add<uint16_t>(0x00);
	output->addByte(random_range(0, 0xFF));

	// Go back and write checksum
	output->skipBytes(-12);
	output->add<uint32_t>(adlerChecksum(output->getOutputBuffer() + sizeof(uint32_t), 8));

	send(output);
}

void ProtocolGame::onRecvFirstMessage(NetworkMessage& msg)
{
	if(
#if defined(WINDOWS) && !defined(_CONSOLE)
		!GUI::getInstance()->m_connections ||
#endif
		g_game.getGameState() == GAMESTATE_SHUTDOWN)
	{
		disconnect();
		return;
	}

	OperatingSystem_t operatingSystem = (OperatingSystem_t)msg.get<uint16_t>();
	uint16_t version = msg.get<uint16_t>();

	if(!RSA_decrypt(msg))
	{
		disconnect();
		return;
	}

	uint32_t key[4] = {msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>()};
	enableXTEAEncryption();
	setXTEAKey(key);
	if(operatingSystem >= CLIENTOS_OTCLIENT_LINUX)
		sendExtendedOpcode(0x00, std::string());

	bool gamemaster = (msg.get<char>() != (char)0);
	std::string name = msg.getString(), character = msg.getString(), password = msg.getString();

	msg.skipBytes(6);
	if(!g_config.getBool(ConfigManager::MANUAL_ADVANCED_CONFIG))
	{
		if(version < CLIENT_VERSION_MIN || version > CLIENT_VERSION_MAX)
		{
			disconnectClient(0x14, CLIENT_VERSION_STRING);
			return;
		}
	else
		if(version < g_config.getNumber(ConfigManager::VERSION_MIN) || version > g_config.getNumber(ConfigManager::VERSION_MAX))
		{
			disconnectClient(0x14, g_config.getString(ConfigManager::VERSION_MSG).c_str());
			return;
		}
	}

	if(name.empty())
	{
		name = "10";
	}

	if(g_game.getGameState() < GAMESTATE_NORMAL)
	{
		disconnectClient(0x14, "Gameworld is just starting up, please wait.");
		return;
	}

	if(g_game.getGameState() == GAMESTATE_MAINTAIN)
	{
		disconnectClient(0x14, "Gameworld is under maintenance, please re-connect in a while.");
		return;
	}

	if(IOBan::getInstance()->isIpBanished(getIP()))
	{
		disconnectClient(0x14, "Your IP is banished!");
		return;
	}

	uint32_t id = 1;
	if(!IOLoginData::getInstance()->getAccountId(name, id))
	{
		disconnectClient(0x14, "Invalid account name.");
		return;
	}

	std::string hash, salt;
	if(name != "10" && (!IOLoginData::getInstance()->getPassword(id, hash, salt, character) || !encryptTest(salt + password, hash)))
	{
		disconnectClient(0x14, "Invalid password.");
		return;
	}

	Ban ban;
	ban.value = id;

	ban.type = BAN_ACCOUNT;
	if(IOBan::getInstance()->getData(ban) && !IOLoginData::getInstance()->hasFlag(id, PlayerFlag_CannotBeBanned))
	{
		bool deletion = ban.expires < 0;
		std::string name_ = "Automatic ";
		if(!ban.adminId)
			name_ += (deletion ? "deletion" : "banishment");
		else
			IOLoginData::getInstance()->getNameByGuid(ban.adminId, name_, true);

		std::stringstream stream;
		stream << "Your account has been " << (deletion ? "deleted" : "banished") << " at:\n" << formatDateEx(ban.added, "%d %b %Y").c_str() << " by: " << name_.c_str()
			   << ".\nThe comment given was:\n" << ban.comment.c_str() << ".\nYour " << (deletion ? "account won't be undeleted" : "banishment will be lifted at:\n")
			   << (deletion ? "" : formatDateEx(ban.expires).c_str()) << ".";

		disconnectClient(0x14, stream.str().c_str());
		return;
	}

	if(name == "10")
		Dispatcher::getInstance().addTask(createTask(boost::bind(
			&ProtocolGame::spectate, getThis(), character, password, version)));
	else
		Dispatcher::getInstance().addTask(createTask(boost::bind(
			&ProtocolGame::login, getThis(), character, id, password, operatingSystem, version, gamemaster)));

}

void ProtocolGame::parsePacket(NetworkMessage &msg)
{
	if(!player || !acceptPackets || g_game.getGameState() == GAMESTATE_SHUTDOWN || msg.getLength() <= 0)
		return;

	uint32_t now = time(NULL);
	if(m_packetTime != now)
	{
		m_packetTime = now;
		m_packetCount = 0;
	}

	++m_packetCount;
	if(m_packetCount > (uint32_t)g_config.getNumber(ConfigManager::PACKETS_PER_SECOND))
		return;

	uint8_t recvbyte = msg.get<char>();
	if(player->isRemoved() && recvbyte != 0x14) //a dead player cannot performs actions
		return;

	if(m_spectator)
	{
		switch(recvbyte)
		{
			case 0x14: parseLogout(msg); break;
			case 0x96: parseSay(msg); break;
			case 0x1E: parseReceivePing(msg); break;
			case 0x97: parseGetChannels(msg); break;
			case 0x98: parseOpenChannel(msg); break;
			case 0xC9: parseUpdateTile(msg); break;
			case 0xCA: parseUpdateContainer(msg); break;
			case 0xE8: parseDebugAssert(msg); break;
			case 0xA1: parseCancelTarget(msg); break;
			case 0x8C: parseLookAt(msg); break;

			// Ctrl + Arrow
			case 0x6F:
			case 0x70:
			case 0x71:
			case 0x72:
				Dispatcher::getInstance().addTask(
						createTask(boost::bind(&ProtocolGame::spectatorTurn, this, recvbyte - 0x6F)));
				break;

			default:
				parseCancelWalk(msg);
			break;
		}
	}
	else if(player->isAccountManager())
	{
		switch(recvbyte)
		{
			case 0x14: parseLogout(msg); break;
			case 0x96: parseSay(msg); break;
			case 0x1E: parseReceivePing(msg); break;
			case 0xC9: parseUpdateTile(msg); break;
			case 0xE8: parseDebugAssert(msg); break;
			case 0xA1: parseCancelTarget(msg); break;

			default:
				parseCancelWalk(msg);
			break;
		}
	}
	else
	{
		switch(recvbyte)
		{
			case 0x14: parseLogout(msg); break;
			case 0x1E: parseReceivePing(msg); break;
			case 0x32: parseExtendedOpcode(msg); break;
			case 0x64: parseAutoWalk(msg); break;
			case 0x65:
			case 0x66:
			case 0x67:
			case 0x68: parseMove(msg, (Direction)(recvbyte - 0x65)); break;
			case 0x69: addGameTask(&Game::playerStopAutoWalk, player->getID()); break;
			case 0x6A: parseMove(msg, NORTHEAST); break;
			case 0x6B: parseMove(msg, SOUTHEAST); break;
			case 0x6C: parseMove(msg, SOUTHWEST); break;
			case 0x6D: parseMove(msg, NORTHWEST); break;
			case 0x6F:
			case 0x70:
			case 0x71:
			case 0x72: parseTurn(msg, (Direction)(recvbyte - 0x6F)); break;
			case 0x78: parseThrow(msg); break;
			case 0x79: parseLookInShop(msg); break;
			case 0x7A: parsePlayerPurchase(msg); break;
			case 0x7B: parsePlayerSale(msg); break;
			case 0x7C: parseCloseShop(msg); break;
			case 0x7D: parseRequestTrade(msg); break;
			case 0x7E: parseLookInTrade(msg); break;
			case 0x7F: parseAcceptTrade(msg); break;
			case 0x80: parseCloseTrade(); break;
			case 0x82: parseUseItem(msg); break;
			case 0x83: parseUseItemEx(msg); break;
			case 0x84: parseBattleWindow(msg); break;
			case 0x85: parseRotateItem(msg); break;
			case 0x87: parseCloseContainer(msg); break;
			case 0x88: parseUpArrowContainer(msg); break;
			case 0x89: parseTextWindow(msg); break;
			case 0x8A: parseHouseWindow(msg); break;
			case 0x8C: parseLookAt(msg); break;
			case 0x8D: parseLookInBattleList(msg); break;
			case 0x96: parseSay(msg); break;
			case 0x97: parseGetChannels(msg); break;
			case 0x98: parseOpenChannel(msg); break;
			case 0x99: parseCloseChannel(msg); break;
			case 0x9A: parseOpenPrivate(msg); break;
			case 0x9E: parseCloseNpc(msg); break;
			case 0x9B: parseProcessRuleViolation(msg); break;
			case 0x9C: parseCloseRuleViolation(msg); break;
			case 0x9D: parseCancelRuleViolation(msg); break;
			case 0xA0: parseFightModes(msg); break;
			case 0xA1: parseAttack(msg); break;
			case 0xA2: parseFollow(msg); break;
			case 0xA3: parseInviteToParty(msg); break;
			case 0xA4: parseJoinParty(msg); break;
			case 0xA5: parseRevokePartyInvite(msg); break;
			case 0xA6: parsePassPartyLeadership(msg); break;
			case 0xA7: parseLeaveParty(msg); break;
			case 0xA8: parseSharePartyExperience(msg); break;
			case 0xAA: parseCreatePrivateChannel(msg); break;
			case 0xAB: parseChannelInvite(msg); break;
			case 0xAC: parseChannelExclude(msg); break;
			case 0xBE: parseCancelMove(msg); break;
			case 0xC9: parseUpdateTile(msg); break;
			case 0xCA: parseUpdateContainer(msg); break;
			case 0xD2:
				if((!player->hasCustomFlag(PlayerCustomFlag_GamemasterPrivileges) || !g_config.getBool(
					ConfigManager::DISABLE_OUTFITS_PRIVILEGED)) && (g_config.getBool(ConfigManager::ALLOW_CHANGEOUTFIT)
					|| g_config.getBool(ConfigManager::ALLOW_CHANGECOLORS) || g_config.getBool(ConfigManager::ALLOW_CHANGEADDONS)))
					parseRequestOutfit(msg);
				break;
			case 0xD3:
				if((!player->hasCustomFlag(PlayerCustomFlag_GamemasterPrivileges) || !g_config.getBool(ConfigManager::DISABLE_OUTFITS_PRIVILEGED))
					&& (g_config.getBool(ConfigManager::ALLOW_CHANGECOLORS) || g_config.getBool(ConfigManager::ALLOW_CHANGEOUTFIT)))
					parseSetOutfit(msg);
				break;
			case 0xDC: parseAddVip(msg); break;
			case 0xDD: parseRemoveVip(msg); break;
			case 0xE6: parseBugReport(msg); break;
			case 0xE7: parseViolationWindow(msg); break;
			case 0xE8: parseDebugAssert(msg); break;
			case 0xF0: parseQuests(msg); break;
			case 0xF1: parseQuestInfo(msg); break;
			case 0xF2: parseViolationReport(msg); break;

			default:
			{
				std::stringstream s;
				s << "Sent unknown byte: 0x" << std::hex << (int16_t)recvbyte << std::dec;
				Logger::getInstance()->eFile("bots/" + player->getName() + ".log", s.str(), true);
				break;
			}
		}
	}
}

void ProtocolGame::GetTileDescription(const Tile* tile, OutputMessage_ptr msg)
{
	int32_t count = 0;
	if(tile->ground)
	{
		msg->addItem(tile->ground, player->getClientVersion());
		++count;
	}

	const TileItemVector* items = tile->getItemList();
	const CreatureVector* creatures = tile->getCreatures();

	ItemVector::const_iterator it;
	if(items)
	{
		for(it = items->getBeginTopItem(); (it != items->getEndTopItem() && count < 10); ++it, ++count)
			msg->addItem(*it, player->getClientVersion());
	}

	if(creatures)
	{
		for(CreatureVector::const_reverse_iterator cit = creatures->rbegin(); (cit != creatures->rend() && count < 10); ++cit)
		{
			if(!player->canSeeCreature(*cit))
				continue;

			bool known;
			uint32_t removedKnown;
			checkCreatureAsKnown((*cit)->getID(), known, removedKnown);

			AddCreature(msg, (*cit), known, removedKnown);
			++count;
		}
	}

	if(items)
	{
		for(it = items->getBeginDownItem(); (it != items->getEndDownItem() && count < 10); ++it, ++count)
			msg->addItem(*it, player->getClientVersion());
	}
}

void ProtocolGame::GetMapDescription(int32_t x, int32_t y, int32_t z,
	int32_t width, int32_t height, OutputMessage_ptr msg, bool storageDynamic)
{
	int32_t skip = -1, startz, endz, zstep = 0;
	if(z > 7)
	{
		startz = z - 2;
		endz = std::min((int32_t)MAP_MAX_LAYERS - 1, z + 2);
		zstep = 1;
	}
	else
	{		
		startz = 7;
		endz = 0;
		zstep = -1;
	}

	for(int32_t nz = startz; nz != endz + zstep; nz += zstep)
		GetFloorDescription(msg, x, y, nz, width, height, z - nz, skip, storageDynamic);
	

	if(skip >= 0)
	{
		msg->addByte(skip);
		msg->addByte(0xFF);
		//cc += skip;
	}
}

void ProtocolGame::GetFloorDescription(OutputMessage_ptr msg, int32_t x, int32_t y, int32_t z,
		int32_t width, int32_t height, int32_t offset, int32_t& skip, bool storageDynamic)
{
	Tile* tile = NULL;
	for(int32_t nx = 0; nx < width; ++nx)
	{
		for(int32_t ny = 0; ny < height; ++ny)
		{
			if((tile = g_game.getTile(Position(x + nx + offset, y + ny + offset, z))))
			{
				if(skip >= 0)
				{
					msg->addByte(skip);
					msg->addByte(0xFF);
				}

				skip = 0;
				GetTileDescription(tile, msg);
			}
			else if(++skip == 0xFF)
			{
				msg->addByte(0xFF);
				msg->addByte(0xFF);
				skip = -1;
			}
		}
	}
}

void ProtocolGame::checkCreatureAsKnown(uint32_t id, bool& known, uint32_t& removedKnown)
{
	auto result = knownCreatureSet.insert(id);
	if (!result.second) {
		known = true;
		return;
	}

	known = false;

	if (knownCreatureSet.size() > 250) {
		// Look for a creature to remove
		for (std::unordered_set<uint32_t>::iterator it = knownCreatureSet.begin(); it != knownCreatureSet.end(); ++it) {
			Creature* creature = g_game.getCreatureByID(*it);
			if (!creature || !canSee(creature)) {
				removedKnown = *it;
				knownCreatureSet.erase(it);
				return;
			}
		}

		// Bad situation. Let's just remove anyone.
		std::unordered_set<uint32_t>::iterator it = knownCreatureSet.begin();
		if (*it == id) {
			++it;
		}

		removedKnown = *it;
		knownCreatureSet.erase(it);
	} else {
		removedKnown = 0;
	}
}

bool ProtocolGame::canSee(const Creature* c) const
{
	return !c->isRemoved() && player->canSeeCreature(c) && canSee(c->getPosition());
}

bool ProtocolGame::canSee(const Position& pos) const
{
	return canSee(pos.x, pos.y, pos.z);
}

bool ProtocolGame::canSee(uint16_t x, uint16_t y, uint16_t z) const
{
	if (!player){
		return false;
	}
	
	const Position& myPos = player->getPosition();
	if(myPos.z <= 7)
	{
		//we are on ground level or above (7 -> 0), view is from 7 -> 0
		if(z > 7)
			return false;
	}
	else if(myPos.z >= 8 && std::abs(myPos.z - z) > 2) //we are underground (8 -> 15), view is +/- 2 from the floor we stand on
		return false;

	//negative offset means that the action taken place is on a lower floor than ourself
	int32_t offsetz = myPos.z - z;
	return ((x >= myPos.x - 8 + offsetz) && (x <= myPos.x + 9 + offsetz) &&
		(y >= myPos.y - 6 + offsetz) && (y <= myPos.y + 7 + offsetz));
}

//********************** Parse methods *******************************//
void ProtocolGame::parseLogout(NetworkMessage&)
{
	if(m_spectator)
		Dispatcher::getInstance().addTask(createTask(boost::bind(&ProtocolGame::disconnect, this)));
	else
		Dispatcher::getInstance().addTask(createTask(boost::bind(&ProtocolGame::logout, this, true, false)));
}

void ProtocolGame::parseCancelWalk(NetworkMessage&)
{
	Dispatcher::getInstance().addTask(createTask(boost::bind(&ProtocolGame::sendCancelWalk, this)));
}

void ProtocolGame::parseCancelTarget(NetworkMessage&)
{
	Dispatcher::getInstance().addTask(createTask(boost::bind(&ProtocolGame::sendCancelTarget, this)));
}

void ProtocolGame::parseCreatePrivateChannel(NetworkMessage&)
{
	addGameTask(&Game::playerCreatePrivateChannel, player->getID());
}

void ProtocolGame::parseChannelInvite(NetworkMessage& msg)
{
	const std::string name = msg.getString();
	addGameTask(&Game::playerChannelInvite, player->getID(), name);
}

void ProtocolGame::parseChannelExclude(NetworkMessage& msg)
{
	const std::string name = msg.getString();
	addGameTask(&Game::playerChannelExclude, player->getID(), name);
}

void ProtocolGame::parseGetChannels(NetworkMessage&)
{
	if(m_spectator)
		Dispatcher::getInstance().addTask(createTask(boost::bind(&ProtocolGame::chat, this, 0)));
	else
		addGameTask(&Game::playerRequestChannels, player->getID());
}

void ProtocolGame::parseOpenChannel(NetworkMessage& msg)
{
	uint16_t channelId = msg.get<uint16_t>();
	if(m_spectator)
		Dispatcher::getInstance().addTask(createTask(boost::bind(&ProtocolGame::chat, this, channelId)));
	else
		addGameTask(&Game::playerOpenChannel, player->getID(), channelId);
}

void ProtocolGame::parseCloseChannel(NetworkMessage& msg)
{
	uint16_t channelId = msg.get<uint16_t>();
	addGameTask(&Game::playerCloseChannel, player->getID(), channelId);
}

void ProtocolGame::parseOpenPrivate(NetworkMessage& msg)
{
	const std::string receiver = msg.getString();
	addGameTask(&Game::playerOpenPrivateChannel, player->getID(), receiver);
}

void ProtocolGame::parseCloseNpc(NetworkMessage&)
{
	addGameTask(&Game::playerCloseNpcChannel, player->getID());
}

void ProtocolGame::parseProcessRuleViolation(NetworkMessage& msg)
{
	const std::string reporter = msg.getString();
	addGameTask(&Game::playerProcessRuleViolation, player->getID(), reporter);
}

void ProtocolGame::parseCloseRuleViolation(NetworkMessage& msg)
{
	const std::string reporter = msg.getString();
	addGameTask(&Game::playerCloseRuleViolation, player->getID(), reporter);
}

void ProtocolGame::parseCancelRuleViolation(NetworkMessage&)
{
	addGameTask(&Game::playerCancelRuleViolation, player->getID());
}

void ProtocolGame::parseViolationWindow(NetworkMessage& msg)
{
	std::string target = msg.getString();
	uint8_t reason = msg.get<char>();
	ViolationAction_t action = (ViolationAction_t)msg.get<char>();
	std::string comment = msg.getString();
	std::string statement = msg.getString();
	uint32_t statementId = (uint32_t)msg.get<uint16_t>();
	bool ipBanishment = (msg.get<char>() == 0x01);
	addGameTask(&Game::playerViolationWindow, player->getID(), target,
		reason, action, comment, statement, statementId, ipBanishment);
}

void ProtocolGame::parseCancelMove(NetworkMessage&)
{
	addGameTask(&Game::playerCancelAttackAndFollow, player->getID());
}

void ProtocolGame::parseReceivePing(NetworkMessage&)
{
	addGameTask(&Game::playerReceivePing, player->getID());
}

void ProtocolGame::parseAutoWalk(NetworkMessage& msg)
{
	uint8_t dirCount = msg.get<char>();
	if(dirCount > 128) //client limit
	{
		for(uint8_t i = 0; i < dirCount; ++i)
			msg.get<char>();

		std::stringstream s;
		s << "Attempt to auto walk for " << (uint16_t)dirCount << " steps - client is limited to 128 steps.";
		Logger::getInstance()->eFile("bots/" + player->getName() + ".log", s.str(), true);
		return;
	}

	std::list<Direction> path;
	for(uint8_t i = 0; i < dirCount; ++i)
	{
		Direction dir = SOUTH;
		switch(msg.get<char>())
		{
			case 1:
				dir = EAST;
				break;
			case 2:
				dir = NORTHEAST;
				break;
			case 3:
				dir = NORTH;
				break;
			case 4:
				dir = NORTHWEST;
				break;
			case 5:
				dir = WEST;
				break;
			case 6:
				dir = SOUTHWEST;
				break;
			case 7:
				dir = SOUTH;
				break;
			case 8:
				dir = SOUTHEAST;
				break;
			default:
				continue;
		}

		path.push_back(dir);
	}

	addGameTask(&Game::playerAutoWalk, player->getID(), path);
}

void ProtocolGame::parseMove(NetworkMessage&, Direction dir)
{
	addGameTask(&Game::playerMove, player->getID(), dir);
}

void ProtocolGame::parseTurn(NetworkMessage&, Direction dir)
{
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerTurn, player->getID(), dir);
}

void ProtocolGame::parseRequestOutfit(NetworkMessage&)
{
	addGameTask(&Game::playerRequestOutfit, player->getID());
}

void ProtocolGame::parseSetOutfit(NetworkMessage& msg)
{
	Outfit_t newOutfit = player->defaultOutfit;
	if(g_config.getBool(ConfigManager::ALLOW_CHANGEOUTFIT))
		newOutfit.lookType = msg.get<uint16_t>();
	else
		msg.skipBytes(2);

	if(g_config.getBool(ConfigManager::ALLOW_CHANGECOLORS))
	{
		newOutfit.lookHead = msg.get<char>();
		newOutfit.lookBody = msg.get<char>();
		newOutfit.lookLegs = msg.get<char>();
		newOutfit.lookFeet = msg.get<char>();
	}
	else
		msg.skipBytes(4);

	if(g_config.getBool(ConfigManager::ALLOW_CHANGEADDONS))
		newOutfit.lookAddons = msg.get<char>();
	else
		msg.skipBytes(1);

	addGameTask(&Game::playerChangeOutfit, player->getID(), newOutfit);
}

void ProtocolGame::parseUseItem(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	int16_t stackpos = msg.get<char>();
	uint8_t index = msg.get<char>();
	bool isHotkey = (pos.x == 0xFFFF && !pos.y && !pos.z);
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerUseItem, player->getID(), pos, stackpos, index, spriteId, isHotkey);
}

void ProtocolGame::parseUseItemEx(NetworkMessage& msg)
{
	Position fromPos = msg.getPosition();
	uint16_t fromSpriteId = msg.get<uint16_t>();
	int16_t fromStackpos = msg.get<char>();
	Position toPos = msg.getPosition();
	uint16_t toSpriteId = msg.get<uint16_t>();
	int16_t toStackpos = msg.get<char>();
	bool isHotkey = (fromPos.x == 0xFFFF && !fromPos.y && !fromPos.z);
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerUseItemEx, player->getID(),
		fromPos, fromStackpos, fromSpriteId, toPos, toStackpos, toSpriteId, isHotkey);
}

void ProtocolGame::parseBattleWindow(NetworkMessage& msg)
{
	Position fromPos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	int16_t fromStackpos = msg.get<char>();
	uint32_t creatureId = msg.get<uint32_t>();
	bool isHotkey = (fromPos.x == 0xFFFF && !fromPos.y && !fromPos.z);
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerUseBattleWindow, player->getID(), fromPos, fromStackpos, creatureId, spriteId, isHotkey);
}

void ProtocolGame::parseCloseContainer(NetworkMessage& msg)
{
	uint8_t cid = msg.get<char>();
	addGameTask(&Game::playerCloseContainer, player->getID(), cid);
}

void ProtocolGame::parseUpArrowContainer(NetworkMessage& msg)
{
	uint8_t cid = msg.get<char>();
	addGameTask(&Game::playerMoveUpContainer, player->getID(), cid);
}

void ProtocolGame::parseUpdateTile(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	addGameTask(&Game::playerUpdateTile, player->getID(), pos);
}

void ProtocolGame::parseUpdateContainer(NetworkMessage& msg)
{
	uint8_t cid = msg.get<char>();
	addGameTask(&Game::playerUpdateContainer, player->getID(), cid);
}

void ProtocolGame::parseThrow(NetworkMessage& msg)
{
	Position fromPos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	int16_t fromStackpos = msg.get<char>();
	Position toPos = msg.getPosition();
	uint8_t count = msg.get<char>();
	if(toPos != fromPos)
		addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerMoveThing,
			player->getID(), fromPos, spriteId, fromStackpos, toPos, count);
}

void ProtocolGame::parseLookAt(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	int16_t stackpos = msg.get<char>();

	if(m_spectator) {
		Dispatcher::getInstance().addTask(
							createTask(boost::bind(&ProtocolGame::lookAt, this, player->getID(), pos, spriteId, stackpos)));
		//addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, this->lookAt, player, pos, spriteId, stackpos);	
	} else {
		addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerLookAt, player->getID(), pos, spriteId, stackpos);		
	}
}

void ProtocolGame::parseLookInBattleList(NetworkMessage& msg)
{
	uint32_t creatureId = msg.get<uint32_t>();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerLookInBattleList, player->getID(), creatureId);
}

void ProtocolGame::parseSay(NetworkMessage& msg)
{
	std::string receiver;
	uint16_t channelId = 0;

	MessageClasses type = (MessageClasses)msg.get<char>();
	switch(type)
	{
		case MSG_PRIVATE:
		case MSG_GAMEMASTER_PRIVATE:
		case MSG_RVR_ANSWER:
			receiver = msg.getString();
			break;

		case MSG_CHANNEL:
		case MSG_CHANNEL_HIGHLIGHT:
		case MSG_GAMEMASTER_CHANNEL:
		case MSG_GAMEMASTER_ANONYMOUS:
			channelId = msg.get<uint16_t>();
			break;

		default:
			break;
	}

	if(m_spectator)
	{
		Dispatcher::getInstance().addTask(createTask(boost::bind(&Spectators::handle, player->client, this, msg.getString(), channelId)));
		return;
	}

	const std::string text = msg.getString();
	if(text.length() > 255) //client limit
	{
		std::stringstream s;
		s << "Attempt to send message with size " << text.length() << " - client is limited to 255 characters.";
		Logger::getInstance()->eFile("bots/" + player->getName() + ".log", s.str(), true);
		return;
	}

	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerSay, player->getID(), channelId, type, receiver, text);
}

void ProtocolGame::parseFightModes(NetworkMessage& msg)
{
	uint8_t rawFightMode = msg.get<char>(); //1 - offensive, 2 - balanced, 3 - defensive
	uint8_t rawChaseMode = msg.get<char>(); //0 - stand while fightning, 1 - chase opponent
	uint8_t rawSecureMode = msg.get<char>(); //0 - can't attack unmarked, 1 - can attack unmarked

	chaseMode_t chaseMode = CHASEMODE_STANDSTILL;
	if(rawChaseMode == 1)
		chaseMode = CHASEMODE_FOLLOW;

	fightMode_t fightMode = FIGHTMODE_ATTACK;
	if(rawFightMode == 2)
		fightMode = FIGHTMODE_BALANCED;
	else if(rawFightMode == 3)
		fightMode = FIGHTMODE_DEFENSE;

	secureMode_t secureMode = SECUREMODE_OFF;
	if(rawSecureMode == 1)
		secureMode = SECUREMODE_ON;

	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerSetFightModes, player->getID(), fightMode, chaseMode, secureMode);
}

void ProtocolGame::parseAttack(NetworkMessage& msg)
{
	uint32_t creatureId = msg.get<uint32_t>();
	//msg.get<uint32_t>(); creatureId (same as above)
	addGameTask(&Game::playerSetAttackedCreature, player->getID(), creatureId);
}

void ProtocolGame::parseFollow(NetworkMessage& msg)
{
	uint32_t creatureId = msg.get<uint32_t>();
	// msg.get<uint32_t>(); creatureId (same as above)
	addGameTask(&Game::playerFollowCreature, player->getID(), creatureId);
}

void ProtocolGame::parseTextWindow(NetworkMessage& msg)
{
	uint32_t windowTextId = msg.get<uint32_t>();
	const std::string newText = msg.getString();
	addGameTask(&Game::playerWriteItem, player->getID(), windowTextId, newText);
}

void ProtocolGame::parseHouseWindow(NetworkMessage &msg)
{
	uint8_t doorId = msg.get<char>();
	uint32_t id = msg.get<uint32_t>();
	const std::string text = msg.getString();
	addGameTask(&Game::playerUpdateHouseWindow, player->getID(), doorId, id, text);
}

void ProtocolGame::parseLookInShop(NetworkMessage &msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t count = msg.get<char>();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerLookInShop, player->getID(), id, count);
}

void ProtocolGame::parsePlayerPurchase(NetworkMessage &msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t count = msg.get<char>();
	uint8_t amount = msg.get<char>();
	bool ignoreCap = (msg.get<char>() != (char)0);
	bool inBackpacks = (msg.get<char>() != (char)0);
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerPurchaseItem, player->getID(), id, count, amount, ignoreCap, inBackpacks);
}

void ProtocolGame::parsePlayerSale(NetworkMessage &msg)
{
	uint16_t id = msg.get<uint16_t>();
	uint8_t count = msg.get<char>();
	uint8_t amount = msg.get<char>();
	bool ignoreEquipped = (msg.get<char>() != (char)0);
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerSellItem, player->getID(), id, count, amount, ignoreEquipped);
}

void ProtocolGame::parseCloseShop(NetworkMessage&)
{
	addGameTask(&Game::playerCloseShop, player->getID());
}

void ProtocolGame::parseRequestTrade(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	int16_t stackpos = msg.get<char>();
	uint32_t playerId = msg.get<uint32_t>();
	addGameTask(&Game::playerRequestTrade, player->getID(), pos, stackpos, playerId, spriteId);
}

void ProtocolGame::parseAcceptTrade(NetworkMessage&)
{
	addGameTask(&Game::playerAcceptTrade, player->getID());
}

void ProtocolGame::parseLookInTrade(NetworkMessage& msg)
{
	bool counter = (msg.get<char>() != (char)0);
	int32_t index = msg.get<char>();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerLookInTrade, player->getID(), counter, index);
}

void ProtocolGame::parseCloseTrade()
{
	addGameTask(&Game::playerCloseTrade, player->getID());
}

void ProtocolGame::parseAddVip(NetworkMessage& msg)
{
	const std::string name = msg.getString();
	if(name.size() > 30)
		return;

	addGameTask(&Game::playerRequestAddVip, player->getID(), name);
}

void ProtocolGame::parseRemoveVip(NetworkMessage& msg)
{
	uint32_t guid = msg.get<uint32_t>();
	addGameTask(&Game::playerRequestRemoveVip, player->getID(), guid);
}

void ProtocolGame::parseRotateItem(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = msg.get<uint16_t>();
	int16_t stackpos = msg.get<char>();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, &Game::playerRotateItem, player->getID(), pos, stackpos, spriteId);
}

void ProtocolGame::parseDebugAssert(NetworkMessage& msg)
{
	if(m_debugAssertSent)
		return;

	std::stringstream s;
	s << "----- " << formatDate() << " - " << player->getName() << " (" << convertIPAddress(getIP())
		<< ") -----" << std::endl
		<< msg.getString() << std::endl
		<< msg.getString() << std::endl
		<< msg.getString() << std::endl
		<< msg.getString() << std::endl
		<< std::endl;

	m_debugAssertSent = true;
	Logger::getInstance()->iFile(LOGFILE_ASSERTIONS, s.str(), false);
}

void ProtocolGame::parseBugReport(NetworkMessage& msg)
{
	std::string comment = msg.getString();
	addGameTask(&Game::playerReportBug, player->getID(), comment);
}

void ProtocolGame::parseInviteToParty(NetworkMessage& msg)
{
	uint32_t targetId = msg.get<uint32_t>();
	addGameTask(&Game::playerInviteToParty, player->getID(), targetId);
}

void ProtocolGame::parseJoinParty(NetworkMessage& msg)
{
	uint32_t targetId = msg.get<uint32_t>();
	addGameTask(&Game::playerJoinParty, player->getID(), targetId);
}

void ProtocolGame::parseRevokePartyInvite(NetworkMessage& msg)
{
	uint32_t targetId = msg.get<uint32_t>();
	addGameTask(&Game::playerRevokePartyInvitation, player->getID(), targetId);
}

void ProtocolGame::parsePassPartyLeadership(NetworkMessage& msg)
{
	uint32_t targetId = msg.get<uint32_t>();
	addGameTask(&Game::playerPassPartyLeadership, player->getID(), targetId);
}

void ProtocolGame::parseLeaveParty(NetworkMessage&)
{
	addGameTask(&Game::playerLeaveParty, player->getID(), false);
}

void ProtocolGame::parseSharePartyExperience(NetworkMessage& msg)
{
	bool activate = (msg.get<char>() != (char)0);
	addGameTask(&Game::playerSharePartyExperience, player->getID(), activate);
}

void ProtocolGame::parseQuests(NetworkMessage&)
{
	addGameTask(&Game::playerQuests, player->getID());
}

void ProtocolGame::parseQuestInfo(NetworkMessage& msg)
{
	uint16_t questId = msg.get<uint16_t>();
	addGameTask(&Game::playerQuestInfo, player->getID(), questId);
}

void ProtocolGame::parseViolationReport(NetworkMessage& msg)
{
	ReportType_t type = (ReportType_t)msg.get<char>();
	uint8_t reason = msg.get<char>();

	std::string name = msg.getString(), comment = msg.getString(), translation = "";
	if(type != REPORT_BOT)
		translation = msg.getString();

	uint32_t statementId = 0;
	if(type == REPORT_STATEMENT)
		statementId = msg.get<uint32_t>();

	addGameTask(&Game::playerReportViolation, player->getID(), type, reason, name, comment, translation, statementId);
}

//********************** Send methods *******************************//
void ProtocolGame::sendOpenPrivateChannel(const std::string& receiver)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xAD);
	msg->addString(receiver);
}

void ProtocolGame::sendCreatureOutfit(const Creature* creature, const Outfit_t& outfit)
{//função executada quando o cara na tela troca o outfit
	if(!canSee(creature))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x8E);
	msg->add<uint32_t>(creature->getID());
	AddCreatureOutfit(msg, creature, outfit);
}

void ProtocolGame::sendCreatureLight(const Creature* creature)
{
	if(!canSee(creature))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddCreatureLight(msg, creature);
}

void ProtocolGame::sendWorldLight(const LightInfo& lightInfo)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddWorldLight(msg, lightInfo);
}

void ProtocolGame::sendCreatureWalkthrough(const Creature* creature, bool walkthrough)
{
	if(!canSee(creature))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x92);
	msg->add<uint32_t>(creature->getID());
	msg->addByte(!walkthrough);
}

void ProtocolGame::sendCreatureShield(const Creature* creature)
{
	if(!canSee(creature))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x91);
	msg->add<uint32_t>(creature->getID());
	msg->addByte(player->getPartyShield(creature));
}

void ProtocolGame::sendCreatureSkull(const Creature* creature)
{
	if(!canSee(creature))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x90);
	msg->add<uint32_t>(creature->getID());
	msg->addByte(player->getSkullType(creature));
}

void ProtocolGame::sendCreatureSquare(const Creature* creature, uint8_t color)
{
	if(!canSee(creature))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x86);
	msg->add<uint32_t>(creature->getID());
	msg->addByte(color);
}

void ProtocolGame::sendTutorial(uint8_t tutorialId)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xDC);
	msg->addByte(tutorialId);
}

void ProtocolGame::sendAddMarker(const Position& pos, MapMarks_t markType, const std::string& desc)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xDD);
	msg->addPosition(pos);
	msg->addByte(markType);
	msg->addString(desc);
}

void ProtocolGame::sendReLoginWindow()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x28);
}

void ProtocolGame::sendStats()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddPlayerStats(msg);
}

void ProtocolGame::sendTextMessage(MessageClasses mClass, const std::string& message)
{
	AddTextMessage(mClass, message);
}

void ProtocolGame::sendClosePrivate(uint16_t channelId)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	if(channelId == CHANNEL_GUILD || channelId == CHANNEL_PARTY)
		g_chat.removeUserFromChannel(player, channelId);

	msg->addByte(0xB3);
	msg->add<uint16_t>(channelId);
}

void ProtocolGame::sendCreatePrivateChannel(uint16_t channelId, const std::string& channelName)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xB2);
	msg->add<uint16_t>(channelId);
	msg->addString(channelName);
}

void ProtocolGame::sendChannelsDialog(const ChannelsList& channels)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xAB);

	msg->addByte(channels.size());
	for(ChannelsList::const_iterator it = channels.begin(); it != channels.end(); ++it)
	{
		msg->add<uint16_t>(it->first);
		msg->addString(it->second);
	}
}

void ProtocolGame::sendChannel(uint16_t channelId, const std::string& channelName)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xAC);

	msg->add<uint16_t>(channelId);
	msg->addString(channelName);
}

void ProtocolGame::sendIcons(int32_t icons)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xA2);
	msg->add<uint16_t>(icons);
}

void ProtocolGame::sendContainer(uint32_t cid, const Container* container, bool hasParent)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x6E);
	msg->addByte(cid);

	msg->addItem(container, player->getClientVersion());
	msg->addString(container->getName());
	msg->addByte(container->capacity());

	msg->addByte(hasParent ? 0x01 : 0x00);
	msg->addByte(std::min(container->size(), 255U));

	ItemList::const_iterator cit = container->getItems();
	for(uint32_t i = 0; cit != container->getEnd() && i < 255; ++cit, ++i)
		msg->addItem(*cit, player->getClientVersion());
}

void ProtocolGame::sendShop(Npc*, const ShopInfoList& shop)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x7A);
	msg->addByte(std::min(shop.size(), (size_t)255));

	ShopInfoList::const_iterator it = shop.begin();
	for(uint16_t i = 0; it != shop.end() && i < 255; ++it, ++i)
		AddShopItem(msg, (*it), player->getClientVersion());
}

void ProtocolGame::sendCloseShop()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x7C);
}

void ProtocolGame::sendGoods(const ShopInfoList& shop)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x7B);
	msg->add<uint32_t>((uint32_t)g_game.getMoney(player));

	std::map<uint32_t, uint32_t> goodsMap;
	if(shop.size() >= 5)
	{
		for(ShopInfoList::const_iterator sit = shop.begin(); sit != shop.end(); ++sit)
		{
			if(sit->sellPrice < 0)
				continue;

			int8_t subType = -1;
			if(sit->subType)
			{
				const ItemType& it = Item::items[sit->itemId];
				if(it.hasSubType() && !it.stackable)
					subType = sit->subType;
			}

			uint32_t count = player->__getItemTypeCount(sit->itemId, subType);
			if(count > 0)
				goodsMap[sit->itemId] = count;
		}
	}
	else
	{
		std::map<uint32_t, uint32_t> tmpMap;
		player->__getAllItemTypeCount(tmpMap);
		for(ShopInfoList::const_iterator sit = shop.begin(); sit != shop.end(); ++sit)
		{
			if(sit->sellPrice < 0)
				continue;

			int8_t subType = -1;
			const ItemType& it = Item::items[sit->itemId];
			if(sit->subType && it.hasSubType() && !it.stackable)
				subType = sit->subType;

			if(subType != -1)
			{
				uint32_t count = subType;
				if(!it.isFluidContainer() && !it.isSplash())
					count = player->__getItemTypeCount(sit->itemId, subType);

				if(count > 0)
					goodsMap[sit->itemId] = count;
				else
					goodsMap[sit->itemId] = 0;
			}
			else
				goodsMap[sit->itemId] = tmpMap[sit->itemId];
		}
	}

	msg->addByte(std::min(goodsMap.size(), (size_t)255));
	std::map<uint32_t, uint32_t>::const_iterator it = goodsMap.begin();
	for(uint32_t i = 0; it != goodsMap.end() && i < 255; ++it, ++i)
	{
		msg->addItemId(it->first, player->getClientVersion());
		msg->addByte(std::min(it->second, (uint32_t)255));
	}
}

void ProtocolGame::sendRuleViolationsChannel(uint16_t channelId)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(msg)
	{
		TRACK_MESSAGE(msg);
		msg->addByte(0xAE);
		msg->add<uint16_t>(channelId);
		for(RuleViolationsMap::const_iterator it = g_game.getRuleViolations().begin(); it != g_game.getRuleViolations().end(); ++it)
		{
			RuleViolation& rvr = *it->second;
			if(rvr.isOpen && rvr.reporter)
				AddCreatureSpeak(msg, rvr.reporter, MSG_RVR_CHANNEL, rvr.text, channelId, NULL, rvr.time);
		}
	}
}

void ProtocolGame::sendRemoveReport(const std::string& name)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(msg)
	{
		TRACK_MESSAGE(msg);
		msg->addByte(0xAF);
		msg->addString(name);
	}
}

void ProtocolGame::sendRuleViolationCancel(const std::string& name)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(msg)
	{
		TRACK_MESSAGE(msg);
		msg->addByte(0xB0);
		msg->addString(name);
	}
}

void ProtocolGame::sendLockRuleViolation()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(msg)
	{
		TRACK_MESSAGE(msg);
		msg->addByte(0xB1);
	}
}

void ProtocolGame::sendTradeItemRequest(const Player* _player, const Item* item, bool ack)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	if(ack)
		msg->addByte(0x7D);
	else
		msg->addByte(0x7E);

	msg->addString(_player->getName());
	if(const Container* container = item->getContainer())
	{
		msg->addByte(container->getItemHoldingCount() + 1);
		msg->addItem(item, player->getClientVersion());
		for(ContainerIterator it = container->begin(); it != container->end(); ++it)
			msg->addItem(*it, player->getClientVersion());
	}
	else
	{
		msg->addByte(1);
		msg->addItem(item, player->getClientVersion());
	}
}

void ProtocolGame::sendCloseTrade()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x7F);
}

void ProtocolGame::sendCloseContainer(uint32_t cid)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x6F);
	msg->addByte(cid);
}

void ProtocolGame::sendCreatureTurn(const Creature* creature, int16_t stackpos)
{
	if(stackpos >= 10 || !canSee(creature))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x6B);
	msg->addPosition(creature->getPosition());
	msg->addByte(stackpos);
	msg->add<uint16_t>(0x63);
	msg->add<uint32_t>(creature->getID());
	msg->addByte(creature->getDirection());
}

void ProtocolGame::sendCreatureSay(const Creature* creature, MessageClasses type, const std::string& text, Position* pos, uint32_t statementId)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddCreatureSpeak(msg, creature, type, text, 0, pos, statementId);
}

void ProtocolGame::sendCreatureChannelSay(const Creature* creature, MessageClasses type, const std::string& text, uint16_t channelId, uint32_t statementId)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddCreatureSpeak(msg, creature, type, text, channelId, NULL, statementId);
}

void ProtocolGame::sendStatsMessage(MessageClasses type, const std::string& message,
	Position pos, MessageDetails* details/* = NULL*/)
{
	AddTextMessage(type, message, &pos, details);
}

void ProtocolGame::sendCancel(const std::string& message)
{
	AddTextMessage(MSG_STATUS_SMALL, message);
}

void ProtocolGame::sendCancelTarget()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xA3);
	msg->add<uint32_t>(0);
}

void ProtocolGame::sendChangeSpeed(const Creature* creature, uint32_t speed)
{
	if(!canSee(creature))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x8F);
	msg->add<uint32_t>(creature->getID());
	msg->add<uint16_t>(speed);
}

void ProtocolGame::sendCancelWalk()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xB5);
	msg->addByte(player->getDirection());
}

void ProtocolGame::sendSkills()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddPlayerSkills(msg);
}

void ProtocolGame::sendPing()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x1E);
}

void ProtocolGame::sendDistanceShoot(const Position& from, const Position& to, uint8_t type)
{
	if(type > SHOOT_EFFECT_LAST || (!canSee(from) && !canSee(to)))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddDistanceShoot(msg, from, to, type);
}

bool ProtocolGame::lookAt(uint32_t playerId, const Position& pos, uint16_t spriteId, int16_t stackpos)
{
	Player* player = g_game.getPlayerByID(playerId);
	if(!player || player->isRemoved())
		return false;

	Thing* thing = g_game.internalGetThing(player, pos, stackpos, spriteId, STACKPOS_LOOK);
	if(!thing)
	{
		return false;
	}

	Position thingPos = pos;
	if(pos.x == 0xFFFF)
		thingPos = thing->getPosition();

	if(!player->canSee(thingPos))
	{
		return false;
	}

	Position playerPos = player->getPosition();
	int32_t lookDistance = -1;
	if(thing != player)
	{
		lookDistance = std::max(std::abs(playerPos.x - thingPos.x), std::abs(playerPos.y - thingPos.y));
		if(playerPos.z != thingPos.z)
			lookDistance += 15;
	}

	bool deny = false;
	CreatureEventList lookEvents = player->getCreatureEvents(CREATURE_EVENT_LOOK);
	for(CreatureEventList::iterator it = lookEvents.begin(); it != lookEvents.end(); ++it)
	{
		if(!(*it)->executeLook(player, thing, thingPos, stackpos, lookDistance))
			deny = true;
	}

	if(deny)
		return false;

	std::stringstream ss;
	ss << "You see " << thing->getDescription(lookDistance);

	Dispatcher::getInstance().addTask(
						createTask(boost::bind(&ProtocolGame::sendTextMessage, this, MSG_INFO_DESCR, ss.str())));

	return true;
}

void ProtocolGame::sendMagicEffect(const Position& pos, uint8_t type)
{
	if(type > MAGIC_EFFECT_LAST || !canSee(pos))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddMagicEffect(msg, pos, type);
}

void ProtocolGame::sendAnimatedText(const Position& pos, uint8_t color, std::string text)
{
	if(!canSee(pos))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddAnimatedText(msg, pos, color, text);
}

void ProtocolGame::sendCreatureHealth(const Creature* creature)
{
	if(!canSee(creature))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddCreatureHealth(msg, creature);
}

void ProtocolGame::sendFYIBox(const std::string& message)
{
	if(message.empty() || message.length() > 1018) //Prevent client debug when message is empty or length is > 1018 (not confirmed)
	{
		std::clog << "[Warning - ProtocolGame::sendFYIBox] Trying to send an empty or too huge message." << std::endl;
		return;
	}

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x15);
	msg->addString(message);
}

//tile
void ProtocolGame::sendAddTileItem(const Tile*, const Position& pos, uint32_t stackpos, const Item* item)
{
	if(stackpos >= 10 || !canSee(pos))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddTileItem(msg, pos, stackpos, item);
}

void ProtocolGame::sendUpdateTileItem(const Tile*, const Position& pos, uint32_t stackpos, const Item* item)
{
	if(stackpos >= 10 || !canSee(pos))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	UpdateTileItem(msg, pos, stackpos, item);
}

void ProtocolGame::sendRemoveTileItem(const Tile*, const Position& pos, uint32_t stackpos)
{
	if(stackpos >= 10 || !canSee(pos))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	RemoveTileItem(msg, pos, stackpos);
}

void ProtocolGame::sendUpdateTile(const Tile* tile, const Position& pos)
{
	if(!canSee(pos))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x69);
	msg->addPosition(pos);
	if(tile)
	{
		GetTileDescription(tile, msg);
		msg->addByte(0x00);
		msg->addByte(0xFF);
	}
	else
	{
		msg->addByte(0x01);
		msg->addByte(0xFF);
	}
}

void ProtocolGame::sendAddCreature(const Creature* creature, const Position& pos, uint32_t stackpos)
{
	if(!canSee(creature))
		return;

	if(creature != player)
	{
		if (stackpos >= 10) {
			return;
		}

		OutputMessage_ptr msgg = getOutputBuffer();
		if(!msgg)
			return;

		TRACK_MESSAGE(msgg);
		AddTileCreature(msgg, pos, stackpos, creature);
		return;
	}

	// Dynamic Floor View:
	std::string sorageFloor;
	bool storageDynamic = false;
	if(creature->getStorage("586790", sorageFloor)){
		int32_t storageFloorInt = atoi(sorageFloor.c_str());
		if(storageFloorInt){
			storageDynamic = true;
		}
	}

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x0A);
	msg->add<uint32_t>(player->getID());
	msg->add<uint16_t>(0x32);

	msg->addByte(player->hasFlag(PlayerFlag_CanReportBugs));
	if(Group* group = player->getGroup())
	{
		int32_t reasons = group->getViolationReasons();
		if(reasons > 1)
		{
			msg->addByte(0x0B);
			for(int32_t i = 0; i < 20; ++i)
			{
				if(i < 4)
					msg->addByte(group->getNameViolationFlags());
				else if(i < reasons)
					msg->addByte(group->getStatementViolationFlags());
				else
					msg->addByte(0);
			}
		}
	}

	AddMapDescription(msg, pos, storageDynamic);
	for(int32_t i = SLOT_FIRST; i < SLOT_LAST; ++i)
		AddInventoryItem(msg, (slots_t)i, player->getInventoryItem((slots_t)i));

	AddPlayerStats(msg);
	AddPlayerSkills(msg);

	LightInfo lightInfo;
	g_game.getWorldLightInfo(lightInfo);

	AddWorldLight(msg, lightInfo);
	AddCreatureLight(msg, creature);

	player->sendIcons();
	if(m_spectator)
		return;

	for(VIPSet::iterator it = player->VIPList.begin(); it != player->VIPList.end(); ++it)
	{
		std::string vipName;
		if(IOLoginData::getInstance()->getNameByGuid((*it), vipName))
		{
			Player* tmpPlayer = g_game.getPlayerByName(vipName);
			sendVIP((*it), vipName, (tmpPlayer && player->canSeeCreature(tmpPlayer)));
		}
	}
}

void ProtocolGame::sendRemoveCreature(const Creature*, const Position& pos, uint32_t stackpos)
{
	if(stackpos >= 10 || !canSee(pos))
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	RemoveTileItem(msg, pos, stackpos);
}

void ProtocolGame::sendMoveCreature(const Creature* creature, const Tile*, const Position& newPos,
	uint32_t newStackpos, const Tile*, const Position& oldPos, uint32_t oldStackpos, bool teleport)
{
	if(creature == player)
	{
		// Dynamic Floor View:
		std::string sorageFloor;
		bool storageDynamic = false;
		if(creature->getStorage("586790", sorageFloor)){
			int32_t storageFloorInt = atoi(sorageFloor.c_str());
			if(storageFloorInt){
				storageDynamic = true;
			}
		}

		if(teleport || oldStackpos >= 10)
		{
			OutputMessage_ptr msg = getOutputBuffer();
			if(!msg)
				return;

			TRACK_MESSAGE(msg);
			if (oldStackpos < 10)
				RemoveTileItem(msg, oldPos, oldStackpos);
			AddMapDescription(msg, newPos, storageDynamic);
		}
		else
		{
			if(oldPos.z != 7 || newPos.z < 8)
			{
				OutputMessage_ptr msg = getOutputBuffer();
				if(!msg)
					return;

				TRACK_MESSAGE(msg);
				msg->addByte(0x6D);
				msg->addPosition(oldPos);
				msg->addByte(oldStackpos);
				msg->addPosition(newPos);
			}
			else if (oldStackpos < 10) {
				OutputMessage_ptr msg = getOutputBuffer();
				if(!msg)
					return;

				TRACK_MESSAGE(msg);
				RemoveTileItem(msg, oldPos, oldStackpos);
			}

			if(newPos.z > oldPos.z) {
				MoveDownCreature(creature, newPos, oldPos, oldStackpos);
			} else if(newPos.z < oldPos.z) {
				MoveUpCreature(creature, newPos, oldPos, oldStackpos);
			}

			if(oldPos.y > newPos.y) // north, for old x
			{
				OutputMessage_ptr msg = getOutputBuffer();
				if(!msg)
					return;

				TRACK_MESSAGE(msg);
				msg->addByte(0x65);
				GetMapDescription(oldPos.x - 8, newPos.y - 6, newPos.z, 18, 1, msg, storageDynamic);
			}
			else if(oldPos.y < newPos.y) // south, for old x
			{
				OutputMessage_ptr msg = getOutputBuffer();
				if(!msg)
					return;

				TRACK_MESSAGE(msg);
				msg->addByte(0x67);
				GetMapDescription(oldPos.x - 8, newPos.y + 7, newPos.z, 18, 1, msg, storageDynamic);
			}

			if(oldPos.x < newPos.x) // east, [with new y]
			{
				OutputMessage_ptr msg = getOutputBuffer();
				if(!msg)
					return;

				TRACK_MESSAGE(msg);
				msg->addByte(0x66);
				GetMapDescription(newPos.x + 9, newPos.y - 6, newPos.z, 1, 14, msg, storageDynamic);
			}
			else if(oldPos.x > newPos.x) // west, [with new y]
			{
				OutputMessage_ptr msg = getOutputBuffer();
				if(!msg)
					return;

				TRACK_MESSAGE(msg);
				msg->addByte(0x68);
				GetMapDescription(newPos.x - 8, newPos.y - 6, newPos.z, 1, 14, msg, storageDynamic);
			}
		}
	}
	else if(canSee(oldPos) && canSee(newPos))
	{
		if(!player->canSeeCreature(creature))
			return;

		if(!teleport && (oldPos.z != 7 || newPos.z < 8) && oldStackpos < 10)
		{
			OutputMessage_ptr msg = getOutputBuffer();
			if(!msg)
				return;

			TRACK_MESSAGE(msg);
			msg->addByte(0x6D);
			msg->addPosition(oldPos);
			msg->addByte(oldStackpos);
			msg->addPosition(newPos);
		}
		else
		{
			if (oldStackpos < 10 || newStackpos < 10) {
				OutputMessage_ptr msg = getOutputBuffer();
				if(!msg)
					return;

				TRACK_MESSAGE(msg);
				if (oldStackpos < 10)
				RemoveTileItem(msg, oldPos, oldStackpos);

				if (newStackpos < 10) {
					AddTileCreature(msg, newPos, newStackpos, creature);
				}
			}
		}
	}
	else if(canSee(oldPos))
	{
		if(oldStackpos >= 10 || !player->canSeeCreature(creature))
			return;

		OutputMessage_ptr msg = getOutputBuffer();
		if(!msg)
			return;

		TRACK_MESSAGE(msg);
		RemoveTileItem(msg, oldPos, oldStackpos);
	}
	else if(newStackpos < 10 && canSee(newPos) && player->canSeeCreature(creature))
	{
		OutputMessage_ptr msg = getOutputBuffer();
		if(!msg)
			return;

		TRACK_MESSAGE(msg);
		AddTileCreature(msg, newPos, newStackpos, creature);
	}
}

//inventory
void ProtocolGame::sendAddInventoryItem(slots_t slot, const Item* item)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddInventoryItem(msg, slot, item);
}

void ProtocolGame::sendUpdateInventoryItem(slots_t slot, const Item* item)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	UpdateInventoryItem(msg, slot, item);
}

void ProtocolGame::sendRemoveInventoryItem(slots_t slot)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	RemoveInventoryItem(msg, slot);
}

//containers
void ProtocolGame::sendAddContainerItem(uint8_t cid, const Item* item)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	AddContainerItem(msg, cid, item);
}

void ProtocolGame::sendUpdateContainerItem(uint8_t cid, uint8_t slot, const Item* item)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	UpdateContainerItem(msg, cid, slot, item);
}

void ProtocolGame::sendRemoveContainerItem(uint8_t cid, uint8_t slot)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	RemoveContainerItem(msg, cid, slot);
}

void ProtocolGame::sendTextWindow(uint32_t windowTextId, Item* item, uint16_t maxLen, bool canWrite)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x96);
	msg->add<uint32_t>(windowTextId);
	msg->addItem(item, player->getClientVersion());
	if(canWrite)
	{
		msg->add<uint16_t>(maxLen);
		msg->addString(item->getText());
	}
	else
	{
		msg->add<uint16_t>(item->getText().size());
		msg->addString(item->getText());
	}

	const std::string& writer = item->getWriter();
	if(writer.size())
		msg->addString(writer);
	else
		msg->addString("");

	time_t writtenDate = item->getDate();
	if(writtenDate > 0)
		msg->addString(formatDate(writtenDate));
	else
		msg->addString("");
}

void ProtocolGame::sendHouseWindow(uint32_t windowTextId, House*,
	uint32_t, const std::string& text)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0x97);
	msg->addByte(0x00);
	msg->add<uint32_t>(windowTextId);
	msg->addString(text);
}

void ProtocolGame::sendOutfitWindow()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xC8);
	AddCreatureOutfit(msg, player, player->getDefaultOutfit(), true);

	std::list<Outfit> outfitList;
	for(OutfitMap::iterator it = player->outfits.begin(); it != player->outfits.end(); ++it)
	{
		if(player->canWearOutfit(it->first, it->second.addons))
			outfitList.push_back(it->second);
	}

	if(outfitList.size())
	{
		msg->addByte((size_t)std::min((size_t)OUTFITS_MAX_NUMBER, outfitList.size()));
		std::list<Outfit>::iterator it = outfitList.begin();
		for(int32_t i = 0; it != outfitList.end() && i < OUTFITS_MAX_NUMBER; ++it, ++i)
		{
			msg->add<uint16_t>(it->lookType);
			msg->addString(it->name);
			if(player->hasCustomFlag(PlayerCustomFlag_CanWearAllAddons))
				msg->addByte(0x03);
			else if(!g_config.getBool(ConfigManager::ADDONS_PREMIUM) || player->isPremium())
				msg->addByte(it->addons);
			else
				msg->addByte(0x00);
		}
	}
	else
	{
		msg->addByte(1);
		msg->add<uint16_t>(player->getDefaultOutfit().lookType);
		msg->addString("Your outfit");
		msg->addByte(player->getDefaultOutfit().lookAddons);
	}

	player->hasRequestedOutfit(true);
}

void ProtocolGame::sendQuests()
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xF0);

	msg->add<uint16_t>(Quests::getInstance()->getQuestCount(player));
	for(QuestList::const_iterator it = Quests::getInstance()->getFirstQuest(); it != Quests::getInstance()->getLastQuest(); ++it)
	{
		if(!(*it)->isStarted(player))
			continue;

		msg->add<uint16_t>((*it)->getId());
		msg->addString((*it)->getName());
		msg->addByte((*it)->isCompleted(player));
	}
}

void ProtocolGame::sendQuestInfo(Quest* quest)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xF1);
	msg->add<uint16_t>(quest->getId());

	msg->addByte(quest->getMissionCount(player));
	for(MissionList::const_iterator it = quest->getFirstMission(); it != quest->getLastMission(); ++it)
	{
		if(!(*it)->isStarted(player))
			continue;

		msg->addString((*it)->getName(player));
		msg->addString((*it)->getDescription(player));
	}
}

void ProtocolGame::sendVIPLogIn(uint32_t guid)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xD3);
	msg->add<uint32_t>(guid);
}

void ProtocolGame::sendVIPLogOut(uint32_t guid)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xD4);
	msg->add<uint32_t>(guid);
}

void ProtocolGame::sendVIP(uint32_t guid, const std::string& name, bool online)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xD2);
	msg->add<uint32_t>(guid);
	msg->addString(name);
	msg->addByte(online ? 1 : 0);
}

void ProtocolGame::reloadCreature(const Creature* creature)
{
	if(!canSee(creature))
		return;

	// we are cheating the client in here!
	uint32_t stackpos = creature->getTile()->getClientIndexOfThing(player, creature);
	if(stackpos >= 10)
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	if(knownCreatureSet.find(creature->getID()) != knownCreatureSet.end())
	{
		RemoveTileItem(msg, creature->getPosition(), stackpos);
		msg->addByte(0x6A);

		msg->addPosition(creature->getPosition());
		msg->addByte(stackpos);
		AddCreature(msg, creature, false, creature->getID());
	}
	else
	{
		AddTileCreature(msg, creature->getPosition(), stackpos, creature);
	}
}

void ProtocolGame::AddMapDescription(OutputMessage_ptr msg, const Position& pos, bool storageDynamic)
{
	msg->addByte(0x64);
	msg->addPosition(player->getPosition());
	GetMapDescription(pos.x - 8, pos.y - 6, pos.z, 18, 14, msg, storageDynamic);
}

void ProtocolGame::AddTextMessage(MessageClasses mClass, const std::string& message,
	Position* pos/* = NULL*/, MessageDetails* details/* = NULL*/)
{
	if(mClass >= MSG_STATUS_CONSOLE_RED)
	{
		if(mClass <= MSG_STATUS_CONSOLE_BLUE)
		{
			OutputMessage_ptr msg = getOutputBuffer();
			if(!msg)
				return;

			msg->addByte(0xB4);
			msg->addByte(mClass);
			msg->addString(message);
		}

		if(details)
		{
			OutputMessage_ptr msg = getOutputBuffer();
			if(!msg)
				return;

			AddAnimatedText(msg, *pos, details->color, asString(details->value));
			if(details->sub)
				AddAnimatedText(msg, *pos, details->sub->color, asString(details->sub->value));
		}
	}
}

void ProtocolGame::AddAnimatedText(OutputMessage_ptr msg, const Position& pos,
	uint8_t color, const std::string& text)
{
	msg->addByte(0x84);
	msg->addPosition(pos);
	msg->addByte(color);
	msg->addString(text);
}

void ProtocolGame::AddMagicEffect(OutputMessage_ptr msg, const Position& pos, uint8_t type)
{
	msg->addByte(0x83);
	msg->addPosition(pos);
	msg->addByte(type + 1);
}

void ProtocolGame::AddDistanceShoot(OutputMessage_ptr msg, const Position& from, const Position& to,
	uint8_t type)
{
	msg->addByte(0x85);
	msg->addPosition(from);
	msg->addPosition(to);
	msg->addByte(type + 1);
}

void ProtocolGame::AddCreature(OutputMessage_ptr msg, const Creature* creature, bool known, uint32_t remove)
{
	if(!known)
	{
		msg->add<uint16_t>(0x61);
		msg->add<uint32_t>(remove);
		msg->add<uint32_t>(creature->getID());
		msg->addString(creature->getHideName() ? "" : creature->getName());
	}
	else
	{
		msg->add<uint16_t>(0x62);
		msg->add<uint32_t>(creature->getID());
	}

	if(!creature->getHideHealth())
		msg->addByte((uint8_t)std::ceil(creature->getHealth() * 100. / std::max(creature->getMaxHealth(), 1)));
	else
		msg->addByte(0x00);

	msg->addByte((uint8_t)creature->getDirection());
	AddCreatureOutfit(msg, creature, creature->getCurrentOutfit());

	LightInfo lightInfo;
	creature->getCreatureLight(lightInfo);

	msg->addByte(lightInfo.level);
	msg->addByte(lightInfo.color);

	msg->add<uint16_t>(creature->getStepSpeed());
	msg->addByte(player->getSkullType(creature));
	msg->addByte(player->getPartyShield(creature));
	if(!known)
		msg->addByte(player->getGuildEmblem(creature));

	msg->addByte(!player->canWalkthrough(creature));
}

void ProtocolGame::AddPlayerStats(OutputMessage_ptr msg)
{
	msg->addByte(0xA0);
	msg->add<uint16_t>(player->getHealth());
	msg->add<uint16_t>(player->getPlayerInfo(PLAYERINFO_MAXHEALTH));
	msg->add<uint32_t>(uint32_t(player->getFreeCapacity() * 100));
	uint64_t experience = player->getExperience();
	if(experience > 0x7FFFFFFF)
		msg->add<uint32_t>(0x7FFFFFFF);
	else
		msg->add<uint32_t>(experience);

	msg->add<uint16_t>(player->getPlayerInfo(PLAYERINFO_LEVEL));
	msg->addByte(player->getPlayerInfo(PLAYERINFO_LEVELPERCENT));
	msg->add<uint16_t>(player->getPlayerInfo(PLAYERINFO_MANA));
	msg->add<uint16_t>(player->getPlayerInfo(PLAYERINFO_MAXMANA));
	msg->addByte(player->getPlayerInfo(PLAYERINFO_MAGICLEVEL));
	msg->addByte(player->getPlayerInfo(PLAYERINFO_MAGICLEVELPERCENT));
	msg->addByte(player->getPlayerInfo(PLAYERINFO_SOUL));
	msg->add<uint16_t>(player->getStaminaMinutes());
}

void ProtocolGame::AddPlayerSkills(OutputMessage_ptr msg)
{
	msg->addByte(0xA1);
	for(uint8_t i = 0; i <= SKILL_LAST; ++i)
	{
		msg->addByte(player->getSkill((skills_t)i, SKILL_LEVEL));
		msg->addByte(player->getSkill((skills_t)i, SKILL_PERCENT));
	}
}

void ProtocolGame::AddCreatureSpeak(OutputMessage_ptr msg, const Creature* creature, MessageClasses type,
	std::string text, uint16_t channelId, Position* pos, uint32_t statementId)
{
	if(type > MSG_SPEAK_MONSTER_LAST) {
		type = MSG_SPEAK_SAY;
	}

	msg->addByte(0xAA);
	if(creature)
	{
		msg->add<uint32_t>(statementId);
		if(creature->getSpeakType() != MSG_NONE)
			type = creature->getSpeakType();

		switch(type)
		{
			case MSG_GAMEMASTER_ANONYMOUS:
				msg->addString("");
				break;
			case MSG_RVR_ANSWER:
				msg->addString("Gamemaster");
				break;
			default:
				msg->addString(!creature->getHideName() ? creature->getName() : "");
				break;
		}

		const Player* speaker = creature->getPlayer();
		if(speaker && !speaker->isAccountManager() && !speaker->hasCustomFlag(PlayerCustomFlag_HideLevel))
			msg->add<uint16_t>(speaker->getPlayerInfo(PLAYERINFO_LEVEL));
		else
			msg->add<uint16_t>(0x00);
	}
	else
	{
		msg->add<uint32_t>(0x00);
		msg->addString("");
		msg->add<uint16_t>(0x00);
	}

	msg->addByte(type);
	switch(type)
	{
		case MSG_SPEAK_SAY:
		case MSG_SPEAK_WHISPER:
		case MSG_SPEAK_YELL:
		case MSG_SPEAK_MONSTER_SAY:
		case MSG_SPEAK_MONSTER_YELL:
		case MSG_NPC_FROM:
		{
			if(pos)
				msg->addPosition(*pos);
			else if(creature)
				msg->addPosition(creature->getPosition());
			else
				msg->addPosition(Position(0,0,7));

			break;
		}

		case MSG_CHANNEL:
		case MSG_CHANNEL_HIGHLIGHT:
		case MSG_GAMEMASTER_CHANNEL:
		case MSG_GAMEMASTER_ANONYMOUS:
			msg->add<uint16_t>(channelId);
			break;

		case MSG_RVR_CHANNEL:
		{
			msg->add<uint32_t>(uint32_t(OTSYS_TIME() / 1000 & 0xFFFFFFFF) - statementId/*use it as time:)*/);
			break;
		}

		default:
			break;
	}

	msg->addString(text);
}

void ProtocolGame::AddCreatureHealth(OutputMessage_ptr msg,const Creature* creature)
{
	msg->addByte(0x8C);
	msg->add<uint32_t>(creature->getID());
	if(!creature->getHideHealth())
		msg->addByte((uint8_t)std::ceil(creature->getHealth() * 100. / std::max(creature->getMaxHealth(), (int32_t)1)));
	else
		msg->addByte(0x00);
}

void ProtocolGame::AddCreatureOutfit(OutputMessage_ptr msg, const Creature* creature, const Outfit_t& outfit, bool outfitWindow/* = false*/)
{
	if(outfitWindow || (!creature->isInvisible() && (!creature->isGhost()
		|| !g_config.getBool(ConfigManager::GHOST_INVISIBLE_EFFECT))))
	{
		uint16_t looktype = outfit.lookType;
		uint32_t version = (player->client ? player->getClientVersion() : 860);

		if (version <= 860 && looktype > 367) {
			//if (creature->getMonster()) {
			if (looktype == 384) // Guzzlemaw 
				looktype = 295;
			else if (looktype == 385) // Frazzlemaw
				looktype = 313;
			else if (looktype == 386) // silencer
				looktype = 101;
			else if (looktype == 387) // chocking fear
				looktype = 320;
			else if (looktype == 391) // dragonling
				looktype = 362;		
			else if (looktype == 388) // guilt
				looktype = 326;		
			else if (looktype == 389) // retching horror
				looktype = 246;		
			else if (looktype == 393) // elder wyrm
				looktype = 291;		
			else if (looktype == 390) // demon outcast
				looktype = 342;	
			else if (looktype == 394) // Gaz'Haragoth
				looktype = 12;	
			else if (looktype == 395) // grimeleech
				looktype = 320;	
			else if (looktype == 397) // hellflayer
				looktype = 357;
			else if (looktype == 396) // Vexclaw
				looktype = 365;
			else if (looktype == 388) // Sight of Surrender
				looktype = 306;
			else if (looktype == 590) // Roaring Lion && Noble Lion
				looktype = 41;
			else if (looktype == 592) // Blood Priest
				looktype = 58;
			else if (looktype == 593 or looktype == 594) // Ferumbras
				looktype = 229;
			else if (looktype == 595 or looktype == 596) // Plagirath, Shulgrax, Zamulosh, Mazoran, Tarbaz, Ragiaz, The Shatterer, Razzagorn
				looktype = 12;
			else if (looktype == 597) // Shock Head
				looktype = 305;
			else if (looktype == 598) // Falcons
				looktype = 131;
			else if (looktype == 599) // Despair
				looktype = 365;
			else if (looktype == 600) // Boss DL - Falcons
				looktype = 39;
			else if (looktype == 601) // preceptor lazare
				looktype = 57;
			else if (looktype == 602) // true asuras
				looktype = 150;
			else if (looktype == 603) //
				looktype = 231;
			else if (looktype == 604) // Glooth Golem
				looktype = 233;
			else if (looktype == 605) // Metal Gargoyle
				looktype = 310;
			else if (looktype == 606) // 
				looktype = 120;
			else if (looktype == 607) // 
				looktype = 293;
			else if (looktype == 608) // 
				looktype = 365;
			else if (looktype == 609) // 
				looktype = 55;
			else if (looktype == 610) // Minotaur Amazon
				looktype = 253;
			else if (looktype == 611) // Execoutioner
				looktype = 202;

			else if (looktype == 613) // 
				looktype = 254;
			else if (looktype == 614) // 
				looktype = 335;
			else if (looktype == 615) // 
				looktype = 194;
			else if (looktype == 616) // 
				looktype = 19;
			else if (looktype == 617) // 
				looktype = 286;
			else if (looktype == 618) // 
				looktype = 238;
			else if (looktype == 619) // Walker
				looktype = 346;
			else if (looktype == 620)
				looktype = 116;
			else if (looktype == 621)
				looktype = 285;
			else if (looktype == 622)
				looktype = 272;
			else if (looktype == 623)
				looktype = 71;
			else if (looktype == 624)
				looktype = 70;
			else if (looktype == 625)
				looktype = 310;
			else if (looktype == 626)
				looktype = 353;
			else if (looktype == 627)
				looktype = 353;
			else if (looktype == 628)
				looktype = 43;
			else if (looktype == 676)
				looktype = 67;
			else if (looktype == 677)
				looktype = 348;
			else if (looktype == 678)
				looktype = 242;
			else if (looktype == 679)
				looktype = 49;
			else if (looktype == 680)
				looktype = 243;
			else if (looktype == 681)
				looktype = 245;
			else if (looktype == 682)
				looktype = 365;
			else if (looktype == 683)
				looktype = 69;
			else if (looktype == 684)
				looktype = 333;
			else if (looktype == 685)
				looktype = 341;
			else if (looktype == 686)
				looktype = 356;
			else if (looktype == 687)
				looktype = 364;
			else if (looktype == 688)
				looktype = 360;
			else if (looktype == 689)
				looktype = 352;
			else if (looktype == 690)
				looktype = 124;
			else if (looktype == 691)
				looktype = 157;
			else if (looktype == 692)
				looktype = 336;
			else if (looktype == 693)
				looktype = 335;
			else if (looktype == 694)
				looktype = 288;
			else if (looktype == 695)
				looktype = 289;
			else if (looktype == 696)
				looktype = 255;
			else if (looktype == 697)
				looktype = 264;
			else if (looktype == 698)
				looktype = 91;
			else if (looktype == 699)
				looktype = 215;
			else if (looktype == 700)
				looktype = 214;
			else if (looktype == 701)
				looktype = 259;
			else if (looktype == 702)
				looktype = 260;
			else if (looktype == 733) // deepling scout
				looktype = 47;
			else if (looktype == 734) // deepling elite & deepling warrior
				looktype = 46;
			else if (looktype == 735) // deepling guard & deepling tyrant
				looktype = 20;
			else if (looktype == 736) // deepling master librarian & deepling spellsinger
				looktype = 77;
			else if (looktype == 744) // Calamary
				looktype = 44;
			else if (looktype == 748) // fish
				looktype = 11;
			else if (looktype == 749) // Crawler
				looktype = 291;
			else if (looktype == 761) // deepling brawler & deepling worker
				looktype = 47;
			else if (looktype == 736) // deepling spellsinger
				looktype = 77;
			else if (looktype == 752) // floor blob
				looktype = 19;
			else if (looktype == 751) // hive overseer
				looktype = 198;
			else if (looktype == 732) // hive overseer
				looktype = 349;



				//else
					//looktype = 35;
			//} else if (creature->getPlayer()) {
			else if (looktype == 368 or looktype == 403 or looktype == 450 or looktype == 497 or looktype == 544) // citizen (male) -- Retro
				looktype = 128;
			else if (looktype == 369 or looktype == 404 or looktype == 451 or looktype == 498 or looktype == 545) // citizen (female) -- Retro
				looktype = 136;
			else if (looktype == 370 or looktype == 405 or looktype == 452 or looktype == 499 or looktype == 546) // hunter (male) -- Retro
				looktype = 129;
			else if (looktype == 371 or looktype == 406 or looktype == 453 or looktype == 500 or looktype == 547) // hunter (female) -- Retro
				looktype = 137;
			else if (looktype == 372 or looktype == 407 or looktype == 454 or looktype == 501 or looktype == 548) // mage (male) -- Retro
				looktype = 130;
			else if (looktype == 373 or looktype == 408 or looktype == 455 or looktype == 502 or looktype == 549) // mage (female) -- Retro
				looktype = 138;
			else if (looktype == 374 or looktype == 409 or looktype == 456 or looktype == 503 or looktype == 550) // knight (male) -- Retro
				looktype = 131;
			else if (looktype == 375 or looktype == 410 or looktype == 457 or looktype == 504 or looktype == 551) // knight (female) -- Retro
				looktype = 139;
			else if (looktype == 376 or looktype == 411 or looktype == 458 or looktype == 505 or looktype == 552) // nobleman (male) -- Retro
				looktype = 132;
			else if (looktype == 377 or looktype == 412 or looktype == 459 or looktype == 506 or looktype == 553) // noblewoman (female) -- Retro
				looktype = 140;
			else if (looktype == 380 or looktype == 413 or looktype == 460 or looktype == 507 or looktype == 554) // Summoner (male) -- Retro
				looktype = 133;
			else if (looktype == 381 or looktype == 414 or looktype == 461 or looktype == 508 or looktype == 555) // Summoner (female) -- Retro
				looktype = 141;
			else if (looktype == 378 or looktype == 415 or looktype == 462 or looktype == 509 or looktype == 556) // Warrior (male) -- Retro
				looktype = 134;
			else if (looktype == 379 or looktype == 416 or looktype == 463 or looktype == 510 or looktype == 557) // Warrior (female) -- Retro
				looktype = 142;	
			else if (looktype == 417 or looktype == 464 or looktype == 511 or looktype == 558) // Barbarian (male)
				looktype = 143;		
			else if (looktype == 418 or looktype == 465 or looktype == 512 or looktype == 559) // Barbarian (female)
				looktype = 147;	
			else if (looktype == 419 or looktype == 466 or looktype == 513 or looktype == 560) // Druid (male)
				looktype = 144;	
			else if (looktype == 420 or looktype == 467 or looktype == 514 or looktype == 561) // Druid (female)
				looktype = 148;	
			else if (looktype == 421 or looktype == 468 or looktype == 515 or looktype == 562) // Wizard (male)
				looktype = 145;	
			else if (looktype == 422 or looktype == 469 or looktype == 516 or looktype == 563) // Wizard (female)
				looktype = 149;	
			else if (looktype == 423 or looktype == 470 or looktype == 517 or looktype == 564) // Oriental (male)
				looktype = 146;	
			else if (looktype == 424 or looktype == 471 or looktype == 518 or looktype == 565) // Oriental (female)
				looktype = 150;	
			else if (looktype == 425 or looktype == 472 or looktype == 519 or looktype == 566) // Pirate (male)
				looktype = 151;	
			else if (looktype == 426 or looktype == 473 or looktype == 520 or looktype == 567) // Pirate (female)
				looktype = 155;	
			else if (looktype == 427 or looktype == 474 or looktype == 521 or looktype == 568) // Assassin (male)
				looktype = 152;	
			else if (looktype == 428 or looktype == 475 or looktype == 522 or looktype == 569) // Assassin (female)
				looktype = 156;	
			else if (looktype == 429 or looktype == 476 or looktype == 523 or looktype == 570) // Beggar (male)
				looktype = 153;	
			else if (looktype == 430 or looktype == 477 or looktype == 524 or looktype == 571) // Beggar (female)
				looktype = 157;	
			else if (looktype == 431 or looktype == 478 or looktype == 525 or looktype == 572) // Shaman (male)
				looktype = 154;	
			else if (looktype == 432 or looktype == 479 or looktype == 526 or looktype == 573) // Shaman (female)
				looktype = 158;	
			else if (looktype == 433 or looktype == 480 or looktype == 527 or looktype == 574) // Norseman (male)
				looktype = 251;	
			else if (looktype == 434 or looktype == 481 or looktype == 528 or looktype == 575) // Norseman (female)
				looktype = 252;	
			else if (looktype == 435 or looktype == 482 or looktype == 529 or looktype == 576) // Nightmare (male)
				looktype = 268;	
			else if (looktype == 436 or looktype == 483 or looktype == 530 or looktype == 577) // Nightmare (female)
				looktype = 269;	
			else if (looktype == 437 or looktype == 484 or looktype == 531 or looktype == 578) // Jester (male)
				looktype = 273;	
			else if (looktype == 438 or looktype == 485 or looktype == 532 or looktype == 579) // Jester (female)
				looktype = 270;	
			else if (looktype == 439 or looktype == 486 or looktype == 533 or looktype == 580) // Brotherhood (male)
				looktype = 278;	
			else if (looktype == 440 or looktype == 487 or looktype == 534 or looktype == 581) // Brotherhood (female)
				looktype = 279;	
			else if (looktype == 441 or looktype == 488 or looktype == 535 or looktype == 582) // Demonhunter (male)
				looktype = 289;	
			else if (looktype == 442 or looktype == 489 or looktype == 536 or looktype == 583) // Demonhunter (female)
				looktype = 288;	
			else if (looktype == 443 or looktype == 490 or looktype == 537 or looktype == 584) // Yalaharian (male)
				looktype = 325;	
			else if (looktype == 444 or looktype == 491 or looktype == 538 or looktype == 585) // Yalaharian (female)
				looktype = 324;	
			else if (looktype == 445 or looktype == 492 or looktype == 539 or looktype == 586) // Warmaster (male)
				looktype = 335;	
			else if (looktype == 446 or looktype == 493 or looktype == 540 or looktype == 587) // Warmaster (female)
				looktype = 336;	
			else if (looktype == 447 or looktype == 494 or looktype == 541 or looktype == 588) // Wayfarer (male)
				looktype = 367;	
			else if (looktype == 448 or looktype == 495 or looktype == 542 or looktype == 589) // Wayfarer (female)
				looktype = 366;	
			else if (looktype == 382) // GM Retro
				looktype = 73;
			else if (looktype == 383) // GOD Colours
				looktype = 302;
			else if (looktype == 398) // Golden Outfit (male)
				looktype = 332;
			else if (looktype == 399) // Golden Outfit (female)
				looktype = 331;
			else if (creature->getMonster())
				looktype = 35;
			else
				looktype = 128;
		}
		msg->add<uint16_t>(looktype);
		if(outfit.lookType)
		{
			msg->addByte(outfit.lookHead);
			msg->addByte(outfit.lookBody);
			msg->addByte(outfit.lookLegs);
			msg->addByte(outfit.lookFeet);
			msg->addByte(outfit.lookAddons);
		}
		else if(outfit.lookTypeEx)
			msg->addItemId(outfit.lookTypeEx, player->getClientVersion());
		else
			msg->add<uint16_t>(outfit.lookTypeEx);
	}
	else
		msg->add<uint32_t>(0x00);
}

void ProtocolGame::AddWorldLight(OutputMessage_ptr msg, const LightInfo& lightInfo)
{
	msg->addByte(0x82);
	msg->addByte(lightInfo.level);
	msg->addByte(lightInfo.color);
}

void ProtocolGame::AddCreatureLight(OutputMessage_ptr msg, const Creature* creature)
{
	msg->addByte(0x8D);
	msg->add<uint32_t>(creature->getID());

	LightInfo lightInfo;
	creature->getCreatureLight(lightInfo);

	msg->addByte(lightInfo.level);
	msg->addByte(lightInfo.color);
}

//tile
void ProtocolGame::AddTileItem(OutputMessage_ptr msg, const Position& pos, uint32_t stackpos, const Item* item)
{
	if (stackpos >= 10) return;

	msg->addByte(0x6A);
	msg->addPosition(pos);
	msg->addByte(stackpos);
	msg->addItem(item, player->getClientVersion());
}

void ProtocolGame::AddTileCreature(OutputMessage_ptr msg, const Position& pos, uint32_t stackpos, const Creature* creature)
{
	if (stackpos >= 10) return;

	msg->addByte(0x6A);
	msg->addPosition(pos);
	msg->addByte(stackpos);

	bool known;
	uint32_t removedKnown;
	checkCreatureAsKnown(creature->getID(), known, removedKnown);
	AddCreature(msg, creature, known, removedKnown);
}

void ProtocolGame::UpdateTileItem(OutputMessage_ptr msg, const Position& pos, uint32_t stackpos, const Item* item)
{
	if (stackpos >= 10) return;

	msg->addByte(0x6B);
	msg->addPosition(pos);
	msg->addByte(stackpos);
	msg->addItem(item, player->getClientVersion());
}

void ProtocolGame::RemoveTileItem(OutputMessage_ptr msg, const Position& pos, uint32_t stackpos)
{
	if (stackpos >= 10) return;

	msg->addByte(0x6C);
	msg->addPosition(pos);
	msg->addByte(stackpos);
}

void ProtocolGame::MoveUpCreature(const Creature* creature,
	const Position& newPos, const Position& oldPos, uint32_t)
{
	if(creature != player)
		return;

	// Dynamic Floor View:
	std::string sorageFloor;
	bool storageDynamic = false;
	if(creature->getStorage("586790", sorageFloor)){
		int32_t storageFloorInt = atoi(sorageFloor.c_str());
		if(storageFloorInt){
			storageDynamic = true;
		}
	}

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);

	msg->addByte(0xBE); //floor change up
	if(newPos.z == 7) //going to surface
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 5, 18, 14, 3, skip, storageDynamic); //(floor 7 and 6 already set)
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 4, 18, 14, 4, skip, storageDynamic);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 3, 18, 14, 5, skip, storageDynamic);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 2, 18, 14, 6, skip, storageDynamic);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 1, 18, 14, 7, skip, storageDynamic);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, 0, 18, 14, 8, skip, storageDynamic);
		if(skip >= 0)
		{
			msg->addByte(skip);
			msg->addByte(0xFF);
		}
	}
	else if(newPos.z > 7) //underground, going one floor up (still underground)
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, oldPos.z - 3, 18, 14, 3, skip, storageDynamic);
		if(skip >= 0)
		{
			msg->addByte(skip);
			msg->addByte(0xFF);
		}
	}

	//moving up a floor up makes us out of sync
	//west
	msg->addByte(0x68);
	GetMapDescription(oldPos.x - 8, oldPos.y + 1 - 6, newPos.z, 1, 14, msg, storageDynamic);

	//north
	msg->addByte(0x65);
	GetMapDescription(oldPos.x - 8, oldPos.y - 6, newPos.z, 18, 1, msg, storageDynamic);
}

void ProtocolGame::MoveDownCreature(const Creature* creature,
	const Position& newPos, const Position& oldPos, uint32_t)
{
	if(creature != player)
		return;

	// Dynamic Floor View:
	std::string sorageFloor;
	bool storageDynamic = false;
	if(creature->getStorage("586790", sorageFloor)){
		int32_t storageFloorInt = atoi(sorageFloor.c_str());
		if(storageFloorInt){
			storageDynamic = true;
		}
	}

	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	msg->addByte(0xBF); //floor change down
	if(newPos.z == 8) //going from surface to underground
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, newPos.z, 18, 14, -1, skip, storageDynamic);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, newPos.z + 1, 18, 14, -2, skip, storageDynamic);
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, newPos.z + 2, 18, 14, -3, skip, storageDynamic);
		if(skip >= 0)
		{
			msg->addByte(skip);
			msg->addByte(0xFF);
		}
	}
	else if(newPos.z > oldPos.z && newPos.z > 8 && newPos.z < 14) //going further down
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - 8, oldPos.y - 6, newPos.z + 2, 18, 14, -3, skip, storageDynamic);
		if(skip >= 0)
		{
			msg->addByte(skip);
			msg->addByte(0xFF);
		}
	}

	//moving down a floor makes us out of sync
	//east
	msg->addByte(0x66);
	GetMapDescription(oldPos.x + 9, oldPos.y - 1 - 6, newPos.z, 1, 14, msg, storageDynamic);

	//south
	msg->addByte(0x67);
	GetMapDescription(oldPos.x - 8, oldPos.y + 7, newPos.z, 18, 1, msg, storageDynamic);
}

//inventory
void ProtocolGame::AddInventoryItem(OutputMessage_ptr msg, slots_t slot, const Item* item)
{
	if(item)
	{
		msg->addByte(0x78);
		msg->addByte(slot);
		msg->addItem(item, player->getClientVersion());
	}
	else
		RemoveInventoryItem(msg, slot);
}

void ProtocolGame::RemoveInventoryItem(OutputMessage_ptr msg, slots_t slot)
{
	msg->addByte(0x79);
	msg->addByte(slot);
}

void ProtocolGame::UpdateInventoryItem(OutputMessage_ptr msg, slots_t slot, const Item* item)
{
	AddInventoryItem(msg, slot, item);
}

//containers
void ProtocolGame::AddContainerItem(OutputMessage_ptr msg, uint8_t cid, const Item* item)
{
	msg->addByte(0x70);
	msg->addByte(cid);
	msg->addItem(item, player->getClientVersion());
}

void ProtocolGame::UpdateContainerItem(OutputMessage_ptr msg, uint8_t cid, uint8_t slot, const Item* item)
{
	msg->addByte(0x71);
	msg->addByte(cid);
	msg->addByte(slot);
	msg->addItem(item, player->getClientVersion());
}

void ProtocolGame::RemoveContainerItem(OutputMessage_ptr msg, uint8_t cid, uint8_t slot)
{
	msg->addByte(0x72);
	msg->addByte(cid);
	msg->addByte(slot);
}

void ProtocolGame::sendChannelMessage(std::string author, std::string text, MessageClasses type, uint16_t channel)
{
	OutputMessage_ptr msg = getOutputBuffer();
	if(!msg)
		return;

	TRACK_MESSAGE(msg);
	msg->addByte(0xAA);
	msg->add<uint32_t>(0x00);
	msg->addString(author);
	msg->add<uint16_t>(0x00);
	msg->addByte(type);
	msg->add<uint16_t>(channel);
	msg->addString(text);
}

void ProtocolGame::AddShopItem(OutputMessage_ptr msg, const ShopInfo& item, uint32_t version)
{
	const ItemType& it = Item::items[item.itemId];

	if (version >= 861 && it.newClientId)
		msg->add<uint16_t>(it.newClientId);
	else
		msg->add<uint16_t>(it.clientId);


	if(it.isSplash() || it.isFluidContainer())
		msg->addByte(serverFluidToClient(item.subType));
	else if(it.stackable || it.charges)
		msg->addByte(item.subType);
	else
		msg->addByte(0x00);

	msg->addString(item.itemName);
	msg->add<uint32_t>(uint32_t(it.weight * 100));
	msg->add<uint32_t>(item.buyPrice);
	msg->add<uint32_t>(item.sellPrice);
}

void ProtocolGame::parseExtendedOpcode(NetworkMessage& msg)
{
	uint8_t opcode = msg.get<char>();
	std::string buffer = msg.getString();

	// process additional opcodes via lua script event
	addGameTask(&Game::parsePlayerExtendedOpcode, player->getID(), opcode, buffer);
}

void ProtocolGame::sendExtendedOpcode(uint8_t opcode, const std::string& buffer)
{
	// extended opcodes can only be send to players using otclient, cipsoft's tibia can't understand them
	if(player && !player->isUsingOtclient())
		return;

	OutputMessage_ptr msg = getOutputBuffer();
	msg->addByte(0x32);
	msg->addByte(opcode);
	msg->addString(buffer);
}
