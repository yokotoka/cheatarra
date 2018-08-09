package ;

@:keep
typedef TComment = {
    var author:String;
    var text:String;
    var dt:Int;
}

@:keep
typedef TPost = {
    var text:String;
    var comments:Array<TComment>;
}

@:keep
typedef TBlog = {
    var posts:Array<TPost>;
    var name:String;
}
@:keep
abstract Comment(TComment) {
    inline public function new(note:TComment) {
        this = note;
    }

    public function getAuthor() {
        return this.author;
    }

}
@:keep
abstract Post(TPost) {
    inline public function new(post:TPost) {
        this = post;
    }

    public function getPostText() {
        return this.text;
    }
}

class Comment2 {
    var author: String;
    var text(get,default): String;
    var dt: Int;
    public function get_text() {
        return this.text;
    }
    public function new(author, text, dt) {
        this.author = author;
        this.text = text;
        this.dt = dt;
    }
}

@:keep
class Post2 {
    var text:String;
    var comments: Array<Comment2>;

    public function new(text, comments) {
        this.text = text;
        this.comments = comments;
    }

}





class Tmp {
    public static function main() {
        trace('hello');

        var j = '{
            "text": "This is my first post",
            "comments": [{
                "author": "yokotoka",
                "text": "Hello, world!",
                "dt": 11122
            }]
        }';

        var x:Post2 = haxe.Json.parse(j);
        //trace(x.text);
        //trace(x.getPostText());
        trace(haxe.Json.stringify(x));
    }
}