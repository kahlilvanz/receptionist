*! Main Programs

#DEFINE APP_PATH	FULLPATH( JUSTPATH( SYS(16,1) ) )

SET DEFAULT TO FULLPATH( JUSTPATH( SYS(16) ) )										&& Set Application Root Directory
SET PATH TO "FORMS;REPORTS;GRAPHICS;DATA;MENUS;PROGS;LIBS;INCLUDES" ADDITIVE		&& Set Application Folders
ON SHUTDOWN AppShutdown( )

SET SAFETY OFF
SET ESCAPE OFF
SET DELETED ON
SET CENTURY ON

SET REPORTBEHAVIOR 80

SQLSETPROP(0,"DispLogin", 3)

#INCLUDE coreheaders.h

SET CLASSLIB TO corelibs.vcx ADDITIVE
SET PROCEDURE TO coreprocedures.prg ADDITIVE


PUBLIC SQLConId

m.SQLConId = 0


DO FORM login

IF _vfp.StartMode != 0
	READ EVENTS
ENDIF

PROCEDURE AppShutdown
	LOCAL handledconnections[1] as array
	
	ASQLHANDLES( m.handledconnections )
	
	
	FOR conid = 1 TO  ALEN( m.handledconnections ,1 )
		
		TRY 
			= SQLDISCONNECT( m.conid )
		CATCH
			*! Ignore error to proceed next connection
		ENDTRY
	ENDFOR
	
	QUIT
	
ENDPROC