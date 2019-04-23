class WebUi
    def index(yaml_str : String)
        %[
<html>

<head>
    <title>EMQ Auth WebUI</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/vue"></script>

    <style>
        nav .brand-logo{
            font-size: 1.2em !important;
            padding-left: 10px !important;
        }

        h1{
            font-size: 1.15em;
        }

        .hidden{
            display:none;
        }

        #yaml_cfg{
            background-color: #f3f3f3;
        }
    </style>
</head>

<body>
    <nav class="indigo darken-4">
        <div class="nav-wrapper">
            <a href="#" class="brand-logo">EMQ Auth WebUI</a>            
        </div>
    </nav>
    <div class="container" id="app">
        <div class="row">
            <div class="col s6">
                <h1>YAML Configuration</h1>
            </div>
            <div class="row">
                <div class="input-field col s12">
                    <textarea v-model="yaml_config" id="yaml_cfg"
                        class="materialize-textarea"></textarea>
                </div>
            </div>
            <pre id="config" class="hidden">#{yaml_str}</pre>
            <div class="col s6">
                <a class="waves-effect waves-light btn" v-on:click="onSave"><i class="material-icons left">save</i>Save</a>
            </div>
        </div>
    </div>
    <script>
        var app = new Vue({
            el: '#app',
            data: {
                    yaml_config: document.getElementById("config").innerHTML
            },
            methods:{
                onSave: (e)=>{
                    console.log("Trying to save", app.yaml_config);
                    fetch(document.location.href + "saveconfig",{
                        method: "POST",
                        body: new URLSearchParams({
                            'yaml': app.yaml_config
                        }),
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    }).then((response)=>{
                        if(response.ok){
                            M.toast({html: 'Configuration saved!'});
                        }else{
                            M.toast({html: 'Error saving ' + response.statusText});
                            var error = new Error(response.statusText)
                            error.response = response
                            throw error
                        }
                    });
                }
            }
        });
    </script>
</body>

</html>
        ]
    end
end