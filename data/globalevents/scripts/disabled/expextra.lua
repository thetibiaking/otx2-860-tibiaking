--- Script by Kekox
function onTime()
                 db.executeQuery("UPDATE accounts SET expextra = extraexp - 1 WHERE expextra > 0;")
        return true
end


