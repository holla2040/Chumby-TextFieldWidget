class TextFieldWidget extends MovieClip {
    var stf:TextField;          // status
    var tf:TextField;           // text
    var urlf:TextField;           // url

    var url = "http://10.210.211.231/kv.php?chumby=1";
    var delay = 5000;
    var nextRefresh = 0;
    var myVars;
    var tfsize = 12;

    function TextFieldWidget() {
        if (_root.config_url != undefined) {
            url = _root.config_url;
        }
        if (_root.config_delay != undefined) {
            delay = int(_root.config_delay);
        }

        if (_root.config_tfsize != undefined) {
            tfsize = int(_root.config_tfsize);
        }

        setstf("requesting");
        seturlf(url);
        settf("");
    }

    function seturlf(text:String) {
        if (!urlf) {
            createTextField("urlf", 19, 1, 0, 280, 15);
            var fmt:TextFormat = new TextFormat();
            fmt.color = 0x0000ff;
            fmt.size = 9;
            fmt.font = "Arial";
            fmt.align = "left";
            urlf.setNewTextFormat(fmt);

        }
        urlf.text = text;
        urlf._visible = true;
    }

    function setstf(text:String) {
        if (!stf) {
            createTextField("stf", 20, 260, 0, 60, 15);
            var fmt:TextFormat = new TextFormat();
            fmt.color = 0x0000ff;
            fmt.size = 9;
            fmt.font = "Arial";
            fmt.align = "right";
            stf.setNewTextFormat(fmt);
        }
        stf.text = text;
        stf._visible = true;
    }

    function settf(text:String) {
        if (!tf) {
            createTextField("tf", 3, 1, 11, 320, 260);
            var fmt:TextFormat = new TextFormat();
            fmt.color = 0x000000;
            fmt.size = tfsize;
            //fmt.bold = true;
            fmt.font = "_typewriter";
            fmt.align = "left";
            tf.setNewTextFormat(fmt);
        }
        tf.text = text;
        tf._visible = true;
    }

    function load() {
        //trace("load");
        myVars = new LoadVars();
        myVars.parent = this;
        
        myVars.onData = function(raw) {
            var now = new Date();
            var t = now.getHours();
            t = t + ":";
            var nMinutes:Number = now.getMinutes();
            t = t + (nMinutes < 10 ? "0" + nMinutes : nMinutes);
            var nSeconds:Number = int(now.getSeconds());
            t = t + ":"+ (nSeconds < 10 ? "0" + nSeconds : nSeconds);
            this.parent.setstf(t);
            this.parent.settf(raw);
        }

        this.setstf("requesting");
        myVars.now = new Date();
        myVars.sendAndLoad(url,myVars,"GET");
    }

    function onEnterFrame() {
        var date = new Date();
        var now = date.getTime();
        if (now > nextRefresh) {
            this.load();
            nextRefresh = now + delay;
        }
    };
}
