component extends="testbox.system.BaseSpec" {

    function beforeAll() {
        variables.DotenvService = createMock( "model.services.DotenvService" );
    };

    function run() {
        describe( "FW/1 Dotenv service", function() {
            it( "Tests exception when file not found", function() {
                var envFile = expandPath( "/resources/.notafile.env" );
                expect( function() { variables.DotenvService.loadSettings( envFile ); } )
                        .toThrow( message = "[fw1dotenv]: Could not find environment file." );
            });

            it( "Tests settings struct is created from a .env properties file", function() {
                var envFile = expandPath( "/resources/.env" );
                var settings = variables.DotenvService.loadSettings( filePath = envFile );
                // Struct returned
                expect( settings ).toBeTypeOf( "struct" );
                // Verify struct data
                expect( settings.testkey ).toBe( "test_env_value" );
            });

            it( "Tests settings struct is created from a standard properties file", function() {
                var envFile = expandPath( "/resources/settings.properties" );
                var settings = variables.DotenvService.loadSettings( filePath = envFile );
                // Struct returned
                expect( settings ).toBeTypeOf( "struct" );
                // Verify struct data
                expect( settings.testkey ).toBe( "test_properties_value" );
            });

            it( "Tests settings struct is created from a json file", function() {
                var envFile = expandPath( "/resources/settings.json" );
                var settings = variables.DotenvService.loadSettings( filePath = envFile );
                // Struct returned
                expect( settings ).toBeTypeOf( "struct" );
                // Verify struct data
                expect( settings.testkey ).toBe( "test_json_value" );
            });
        });
    }

}