<cfscript>
	// Setup result directories (only create if missing)
	resultDir = expandPath( "./result" );
	uploadsDir = resultDir & "/uploads";
	if ( !directoryExists( resultDir ) ) {
		directoryCreate( resultDir );
	}
	if ( !directoryExists( uploadsDir ) ) {
		directoryCreate( uploadsDir );
	}

	testNum = url.test ?: "unknown";

	try {
		switch ( testNum ) {
			case "1":
				// Test 1: Existing directory, no trailing slash
				destination = expandPath( "./result/uploads" );
				cffile(
					action="upload",
					fileField="testfile",
					destination=destination,
					nameConflict="overwrite",
					result="uploadResult"
				);
				writeOutput( "Test 1 - SUCCESS" & chr( 10 ) );
				break;

			case "2":
				// Test 2: Existing directory, WITH trailing slash
				destination = expandPath( "./result/uploads/" );
				cffile(
					action="upload",
					fileField="testfile",
					destination=destination,
					nameConflict="overwrite",
					result="uploadResult"
				);
				writeOutput( "Test 2 - SUCCESS" & chr( 10 ) );
				break;

			case "3":
				// Test 3: Non-existing directory, no trailing slash
				destination = expandPath( "./result/uploads2" );
				cffile(
					action="upload",
					fileField="testfile",
					destination=destination,
					nameConflict="overwrite",
					result="uploadResult"
				);
				writeOutput( "Test 3 - SUCCESS" & chr( 10 ) );
				break;

			case "4":
				// Test 4: Non-existing directory, WITH trailing slash
				destination = expandPath( "./result/uploads3/" );
				cffile(
					action="upload",
					fileField="testfile",
					destination=destination,
					nameConflict="overwrite",
					result="uploadResult"
				);
				writeOutput( "Test 4 - SUCCESS" & chr( 10 ) );
				break;
		}

		writeOutput( "Destination specified: `#destination#`" & chr( 10 ) );
		writeOutput( "File saved to: `#uploadResult.serverDirectory#\#uploadResult.serverFile#`" & chr( 10 ) );
		writeOutput( "Client filename: `#uploadResult.clientFile#`" & chr( 10 ) );
		writeOutput( "Server directory: `#uploadResult.serverDirectory#`" & chr( 10 ) );
		writeOutput( "Server filename: `#uploadResult.serverFile#`" & chr( 10 ) );

		writeOutput( "Result: " & chr( 10 ) );
		writeOutput( "``````" & chr( 10 ) );
		writeOutput( serializeJson( var=uploadResult, compact=false ) & chr( 10 ) );
		writeOutput( "``````" & chr( 10 ) );


		// Check if the file ended up where we expected
		expectedPath = destination;
		if ( !directoryExists( expectedPath ) ) {
			// If destination doesn't exist as a directory, check if it was created as a subdir
			writeOutput( "WARNING: Destination directory does not exist: #expectedPath#" & chr( 10 ) );
			writeOutput( "Checking if subdirectory was created..." & chr( 10 ) );

			// List what actually got created
			baseDir = expandPath( "./" );
			dirs = directoryList( baseDir, false, "query", "*" );
			writeOutput( "Directories in base:" & chr( 10 ) );
			loop query="dirs" {
				if ( dirs.type == "Dir" ) {
					writeOutput( "  - #dirs.name#" & chr( 10 ) );
				}
			}
		}

	} catch ( any e ) {
		writeOutput( "Test #testNum# - ERROR" & chr( 10 ) );
		writeOutput( "Message: #e.message#" & chr( 10 ) );
		writeOutput( "Detail: #e.detail#" & chr( 10 ) );
	}
</cfscript>
