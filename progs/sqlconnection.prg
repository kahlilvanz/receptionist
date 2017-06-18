LPARAMETERS lcServer, lcPort, lcUserId, lcUserKey

#INCLUDE coreheaders.h
SET PROCEDURE TO coreprocedures.prg

ConnectionString = "DRIVER={MySQL ODBC 5.3 Unicode Driver};" + ;
                   "SERVER=" + m.lcServer + ";" + ;
                   "PORT=" + m.lcPort + ";" + ;
                   "DATABASE=patientslog;" + ;
                   "USER=" + m.lcUserId + ";" + ;
                   "PASSWORD=" + m.lcUserKey + ";" + ;
                   "OPTION=16394;"

m.SQLConId = SQLSTRINGCONNECT(m.ConnectionString)
                  
IF m.SQLConId == SQL_ERROR
	ErrInfo( )
	RETURN SQL_ERROR
ENDIF

RETURN SQL_OK