*! System Global Procedures

#INCLUDE coreheaders.h


PROCEDURE RunDefaultApp
	
	LOCAL filereg as 'oldinireg' OF 'registry.vcx'
	LOCAL defaultApp
	
	m.filereg = NEWOBJECT( 'oldinireg','registry.vcx' )
	
	m.filereg.loadinifuncs( )
	
	m.filereg.GetIniEntry( @m.defaultApp, 'CON.CFG', 'DefaultApp', APPSETTING_FILE )
	
	m.defaultApp = INT( VAL( m.defaultApp ) )
	
	DO CASE
		CASE m.defaultApp == DEFAULT_APP_RECEPTIONIST
			DO FORM receptionist
		CASE m.defaultApp == DEFAULT_APP_XRAYLAB
			DO FORM xraylab
	OTHERWISE
		DO FORM appselection
	ENDCASE
	
ENDPROC

PROCEDURE ErrInfo
	LPARAMETERS nErrorCode
	LOCAL errdata[1]
	
	AERROR( m.errdata )
	MESSAGEBOX( m.errdata[2], MSGICON_WARNING, SYSMSG_ERROR )
	
	RETURN IIF( EMPTY( m.nErrorCode ), m.errdata[1], m.nErrorCode )

ENDPROC

PROCEDURE ServerConnect
	LOCAL appsettings as Collection
	
	m.appsettings = RetrieveAppSettings( )
	
	dataserver = m.appsettings.Item('DataServer')
	dataserverport = m.appsettings.Item('DataServerPort')
	dbuserid = m.appsettings.Item('DBUserId')
	dbuserkey = m.appsettings.Item('DBUserKey')

	IF SqlConnection( m.dataserver, m.dataserverport, m.dbuserid, m.dbuserkey ) == SQL_OK
		RETURN RESULT_OK
	ELSE
		RETURN RESULT_ERROR
	ENDIF

ENDPROC

PROCEDURE SaveAppSettings
	LPARAMETERS datasettings as Collection
	
	LOCAL filereg as 'oldinireg' OF 'registry.vcx'
		
	m.filereg = NEWOBJECT( 'oldinireg','registry.vcx' )
	
	m.filereg.loadinifuncs()
	
	m.filereg.WriteINIEntry( m.datasettings.Item('DataServer'), 'CON.CFG', 'SERVER',  APPSETTING_FILE )
	m.filereg.WriteINIEntry( m.datasettings.Item('DataServerPort'), 'CON.CFG', 'SERVERPORT',  APPSETTING_FILE )
	m.filereg.WriteINIEntry( m.datasettings.Item('DBUserId'), 'CON.CFG', 'USERID', APPSETTING_FILE )
	m.filereg.WriteINIEntry( m.datasettings.Item('DBUserKey'), 'CON.CFG', 'USERKey', APPSETTING_FILE )
	m.filereg.WriteINIEntry( m.datasettings.Item('DBRemoteAccess'), 'CON.CFG', 'RemoteAccess', APPSETTING_FILE )	
	m.filereg.WriteINIEntry( m.datasettings.Item('DefaultApp'), 'CON.CFG', 'DefaultApp',  APPSETTING_FILE )
	
	IF m.datasettings.Item('FlagNewPassword')
		m.filereg.WriteINIEntry( m.datasettings.Item('NewPassKey'), 'CON.CFG', '_4VW0OXMLC', APPSETTING_FILE )	
	ENDIF
	
ENDPROC

PROCEDURE SaveSet( )
	LPARAMETERS dataset as Collection
	
	LOCAL filereg as 'oldinireg' OF 'registry.vcx'
		
	m.filereg = NEWOBJECT( 'oldinireg','registry.vcx' )
	
	m.filereg.loadinifuncs()
	
	m.filereg.WriteINIEntry( m.dataset.Item('data'), 'CON.CFG', dataset.Item('entry'),  APPSETTING_FILE )

ENDPROC

PROCEDURE GetSet( )
	LPARAMETERS dataset as Collection
	
	LOCAL keydata as Collection
	LOCAL filereg as 'oldinireg' OF 'registry.vcx'
	
	LOCAL keyValue
		
	m.filereg = NEWOBJECT( 'oldinireg','registry.vcx' )
	m.keydata = NEWOBJECT( 'Collection' )
	
	m.filereg.loadinifuncs()
	
	m.filereg.GetIniEntry( @m.keyValue, 'CON.CFG', dataset.Item('entry'),  APPSETTING_FILE )
	
	m.keydata.Add( m.keyValue, dataset.Item('entry') )
	
	RETURN m.keydata

ENDPROC


PROCEDURE RetrieveAppSettings
	
	LOCAL filereg as 'oldinireg' OF 'registry.vcx'
	LOCAL appsettingdata as Collection
	LOCAL dataserver, dataserverport, dbuserid, dbuserkey, defaultapp, remoteaccess
		
	m.filereg = NEWOBJECT( 'oldinireg','registry.vcx' )
	m.appsettingdata = NEWOBJECT( 'Collection' )
	
	m.filereg.loadinifuncs( )
	
	m.filereg.GetIniEntry( @m.dataserver, 'CON.CFG', 'SERVER', APPSETTING_FILE )
	m.filereg.GetIniEntry( @m.dataserverport, 'CON.CFG', 'SERVERPORT', APPSETTING_FILE )
	m.filereg.GetIniEntry( @m.dbuserid, 'CON.CFG', 'USERID', APPSETTING_FILE )
	m.filereg.GetIniEntry( @m.dbuserkey, 'CON.CFG', 'USERKey', APPSETTING_FILE )
	m.filereg.GetIniEntry( @m.remoteaccess, 'CON.CFG', 'RemoteAccess', APPSETTING_FILE )
	m.filereg.GetIniEntry( @m.defaultapp, 'CON.CFG', 'DefaultApp', APPSETTING_FILE )
	
	m.appsettingdata.Add( IIF( EMPTY( m.dataserver ), '', m.dataserver ), 'DataServer' )
	m.appsettingdata.Add( IIF( EMPTY( m.dataserverport ), '3316', m.dataserverport ), 'DataServerPort' )
	m.appsettingdata.Add( IIF( EMPTY( m.dbuserid ), '', STRCONV( m.dbuserid, 14 ) ), 'DBUserId' )
	m.appsettingdata.Add( IIF( EMPTY( m.dbuserkey ), '', STRCONV( STRCONV( m.dbuserkey, 14 ), 14 ) ), 'DBUserKey' )
	m.appsettingdata.Add( IIF( EMPTY( m.remoteaccess), 0, INT( VAL( m.remoteaccess ) ) ), 'DBRemoteAccess' )
	m.appsettingdata.Add( IIF( EMPTY( m.defaultapp), 0, INT( VAL( m.defaultapp ) ) ), 'DefaultApp' )
	
	RETURN m.appsettingdata
	
ENDPROC

PROCEDURE VerifyPassword
	LPARAMETERS inputpasskey
	
	LOCAL filereg as 'oldinireg' OF 'registry.vcx'
	LOCAL passkey
	
	m.filereg = NEWOBJECT( 'oldinireg','registry.vcx' )
	m.passkey = ''
	
	m.filereg.loadinifuncs( )
	m.filereg.GetIniEntry( @m.passkey, 'CON.CFG', '_4VW0OXMLC', APPSETTING_FILE )	&& Password
	
	m.passkey = STRCONV( STRCONV( m.passkey, 14 ), 14 )	&& decode
	
	RETURN m.inputpasskey == m.passkey
	
ENDPROC