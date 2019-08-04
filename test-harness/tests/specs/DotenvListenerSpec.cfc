component extends="testbox.system.BaseSpec" {

    function __config() {
        return variables.framework;
    }

    function run() {
        describe( "FW/1 Dotenv load listener", function() {
            beforeEach(function( currentSpec ) {
                // Reset the framework instance before each spec is run
                request.delete( "_fw1" );
                variables.fw = new framework.one();
                variables.fw.__config = __config;
                variables.fw.__config().append({
                    subsystems: {
                        fw1dotenv: {
                            diLocations: "/model",
                            diConfig: {
                                omitDirectoryAliases: true,
                                loadListener: "DotenvListener"
                            }
                        }
                    }
                });
            });

            it( "Tests exception when file not found", function() {
                variables.fw.__config().append({
                    dotenv: {
                        fileName: "/resources/.notafile.env"
                    }
                });
                variables.fw.onApplicationStart();

                expect( function() { variables.fw.getBeanFactory().getBean( "SystemSettings" ); } )
                        .toThrow( message = "[fw1dotenv]: Could not find environment file." );
            });

            it( "Tests SystemSettings bean is created from a .env properties file", function() {
                variables.fw.__config().append({
                    dotenv: {
                        fileName: "/resources/.env"
                    }
                });
                variables.fw.onApplicationStart();

                var beanExists = variables.fw.getBeanFactory( "fw1dotenv" ).containsBean( "SystemSettings" );
                expect( beanExists ).toBeTrue();

                var beanType = variables.fw.getBeanFactory( "fw1dotenv" ).getBean( "SystemSettings" );
                expect( beanType ).toBeTypeOf( "struct" );

                var beanVal = variables.fw.getBeanFactory( "fw1dotenv" ).getBean( "SystemSettings" ).testkey;
                expect( beanVal ).toBe( "test_env_value" );
            });

            it( "Tests SystemSettings bean is created from a standard properties file", function() {
                variables.fw.__config().append({
                    dotenv: {
                        fileName: "/resources/settings.properties"
                    }
                });
                variables.fw.onApplicationStart();

                var beanExists = variables.fw.getBeanFactory( "fw1dotenv" ).containsBean( "SystemSettings" );
                expect( beanExists ).toBeTrue();

                var beanType = variables.fw.getBeanFactory( "fw1dotenv" ).getBean( "SystemSettings" );
                expect( beanType ).toBeTypeOf( "struct" );

                var beanVal = variables.fw.getBeanFactory( "fw1dotenv" ).getBean( "SystemSettings" ).testkey;
                expect( beanVal ).toBe( "test_properties_value" );
            });

            it( "Tests SystemSettings bean is created from a json file", function() {
                variables.fw.__config().append({
                    dotenv: {
                        fileName: "/resources/settings.json"
                    }
                });
                variables.fw.onApplicationStart();

                var beanExists = variables.fw.getBeanFactory( "fw1dotenv" ).containsBean( "SystemSettings" );
                expect( beanExists ).toBeTrue();

                var beanType = variables.fw.getBeanFactory( "fw1dotenv" ).getBean( "SystemSettings" );
                expect( beanType ).toBeTypeOf( "struct" );

                var beanVal = variables.fw.getBeanFactory( "fw1dotenv" ).getBean( "SystemSettings" ).testkey;
                expect( beanVal ).toBe( "test_json_value" );
            });

            it( "Tests SystemSettings bean is created and aliased with a custom name", function() {
                variables.fw.__config().append({
                    dotenv: {
                        beanAlias: "CustomNameSettings",
                        fileName: "/resources/.env"
                    }
                });
                variables.fw.onApplicationStart();

                var beanExists = variables.fw.getBeanFactory( "fw1dotenv" ).containsBean( "CustomNameSettings" );
                expect( beanExists ).toBeTrue();

                var beanType = variables.fw.getBeanFactory( "fw1dotenv" ).getBean( "CustomNameSettings" );
                expect( beanType ).toBeTypeOf( "struct" );

                var beanVal = variables.fw.getBeanFactory( "fw1dotenv" ).getBean( "CustomNameSettings" ).testkey;
                expect( beanVal ).toBe( "test_env_value" );
            });
        });
    }

}