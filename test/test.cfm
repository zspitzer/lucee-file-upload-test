<cfscript>
	cfheader( name="Content-Type", value="text/plain" );

	function _echo( required string msg ) {
		echo( msg & chr( 10 ) );
	}

	// Cleanup from previous runs
	resultDir = expandPath( "./result" );
	if ( directoryExists( resultDir ) ) {
		directoryDelete( resultDir, true );
	}

	_echo( "#### File Upload Behaviour Test" );
	_echo( "Lucee Version: #server.lucee.version#" );
	_echo( "OS: #server.os.name# #server.os.version# (#server.os.arch#)" );
	_echo( "" );

	// Create test files with meaningful names
	testFiles = [
		{ name: "test1-exists-no-slash.txt", test: 1, desc: "Existing directory, no trailing slash" },
		{ name: "test2-exists-with-slash.txt", test: 2, desc: "Existing directory, WITH trailing slash" },
		{ name: "test3-new-no-slash.txt", test: 3, desc: "Non-existing directory, no trailing slash" },
		{ name: "test4-new-with-slash.txt", test: 4, desc: "Non-existing directory, WITH trailing slash" }
	];

	for ( t in testFiles ) {
		testFilePath = expandPath( "./#t.name#" );
		fileWrite( testFilePath, "Test file: #t.name# - #t.desc#. Created at #now()#" );

		_echo( "###### Test #t.test#: #t.desc#" );
		cfhttp(
			method="POST",
			url="http://localhost:8888/upload.cfm?test=#t.test#",
			throwonerror=true,
			result="result"
		) {
			cfhttpparam( name="testfile", type="file", file=testFilePath );
		}
		_echo( result.filecontent );
		_echo( "" );

		// Cleanup source file
		if ( fileExists( testFilePath ) ) {
			fileDelete( testFilePath );
		}
	}

	// List all files in result directory
	resultPath = expandPath( "." );
	_echo( "###### List *.txt files under [#resultPath#]:" );
	_echo( "``````" );
	
	files = directoryList( resultPath, true, "query", "*.txt" );
	loop query="files" {
		_echo( "#files.directory.replace( resultPath, '' )#/#files.name#" & chr(9) & files.size  );
	}
	_echo( "``````" );

	_echo( "=== Test Complete ===" );
</cfscript>
