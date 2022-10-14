
class PostReader {
    postRead(str) {
        console.log(str);
    }
}
var postReader = new PostReader();


async function loadFileAsString(path) {    
    let request = await fetch(path);

    if (request.status == 200) {
        let blob = await request.blob()
        
        var reader = new FileReader();
        reader.onload = function() {
            postReader.postRead(reader.result);
        }
        
        reader.readAsText(blob);
    }
    else {
        console.error("File at " + path + " not Found")
    }
}