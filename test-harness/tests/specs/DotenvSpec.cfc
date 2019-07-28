component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "Tests FW/1 Dotenv", function() {
            beforeEach(function( currentSpec ) {
                // Reset the framework instance before each spec is run
                request.delete( "_fw1" );
                variables.fw = new framework.one();
                variables.fw.__config = __config;
                variables.fw.__config().append({
                    diLocations: "/model",
                    diConfig: {
                        omitDirectoryAliases: true,
                        loadListener: "DotenvListener"
                    }
                });
            });

            it( "Tests load listener is discovered", function() {
                variables.fw.onApplicationStart();

                // Load listener is loaded
                var moduleExists = variables.fw.getBeanFactory().containsBean( "DotenvListener" );
                expect( moduleExists ).toBeTrue();
            });

            it( "Tests SystemSettings bean is created from a .env properties file", function() {
                variables.fw.__config().append({
                    dotenv: {
                        fileName: "/resources/.env"
                    }
                });
                variables.fw.onApplicationStart();

                // Bean is created
                var beanExists = variables.fw.getBeanFactory().containsBean( "SystemSettings" );
                expect( beanExists ).toBeTrue();

                var beanType = variables.fw.getBeanFactory().getBean( "SystemSettings" );
                expect( beanType ).toBeTypeOf( "struct" );

                var beanVal = variables.fw.getBeanFactory().getBean( "SystemSettings" ).testkey;
                expect( beanVal ).toBe( "test_env_value" );
            });

            it( "Tests SystemSettings bean is created from a standard properties file", function() {
                variables.fw.__config().append({
                    dotenv: {
                        fileName: "/resources/settings.properties"
                    }
                });
                variables.fw.onApplicationStart();

                var beanExists = variables.fw.getBeanFactory().containsBean( "SystemSettings" );
                expect( beanExists ).toBeTrue();

                var beanType = variables.fw.getBeanFactory().getBean( "SystemSettings" );
                expect( beanType ).toBeTypeOf( "struct" );

                var beanVal = variables.fw.getBeanFactory().getBean( "SystemSettings" ).testkey;
                expect( beanVal ).toBe( "test_properties_value" );
            });

            it( "Tests SystemSettings bean is created from a json file", function() {
                variables.fw.__config().append({
                    dotenv: {
                        fileName: "/resources/settings.json"
                    }
                });
                variables.fw.onApplicationStart();

                var beanExists = variables.fw.getBeanFactory().containsBean( "SystemSettings" );
                expect( beanExists ).toBeTrue();

                var beanType = variables.fw.getBeanFactory().getBean( "SystemSettings" );
                expect( beanType ).toBeTypeOf( "struct" );

                var beanVal = variables.fw.getBeanFactory().getBean( "SystemSettings" ).testkey;
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

                var beanExists = variables.fw.getBeanFactory().containsBean( "CustomNameSettings" );
                expect( beanExists ).toBeTrue();

                var beanType = variables.fw.getBeanFactory().getBean( "CustomNameSettings" );
                expect( beanType ).toBeTypeOf( "struct" );

                var beanVal = variables.fw.getBeanFactory().getBean( "CustomNameSettings" ).testkey;
                expect( beanVal ).toBe( "test_env_value" );
            });
        });
    }

    function __config() {
        return variables.framework;
    }

}