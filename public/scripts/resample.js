var Resample = (function (canvas) {

 // (C) WebReflection Mit Style License

 // Resample function, accepts an image
 // as url, base64 string, or Image/HTMLImgElement
 // optional width or height, and a callback
 // to invoke on operation complete
 function Resample(img, width, height, square, onresample) {
  var
   load = typeof img == "string",
   i = load || img;

  if (load) {
   i = new Image;
   i.onload = onload;
   i.onerror = onerror;
  }

  i._onresample = onresample;
  i._width = width;
  i._height = height;
  i._square = square;
  load ? (i.src = img) : onload.call(img);
 }
 
 function onerror() {
  throw ("not found: " + this.src);
 }
 
 function onload() {
  var
   img = this,
   width = img._width,
   height = img._height,
   square = img._square,
   onresample = img._onresample;
   
  width == null && (width = Math.round(img.width * height / img.height));
  height == null && (height = Math.round(img.height * width / img.width));
  if (square){
    width=height=Math.min(width,height);
  }
  delete img._onresample;
  delete img._width;
  delete img._height;
  delete img._square;
  canvas.width = width;
  canvas.height = height;
  context.drawImage(
   img,
   0,0,
   square? Math.min(img.width,img.height) : img.width,
   square? Math.min(img.width,img.height) : img.height,
   0,0,
   width,
   height
  );
  onresample(canvas.toDataURL("image/jpeg",0.75));
 }
 
 var
  context = canvas.getContext("2d");
 
 return Resample;
 
}(
 this.document.createElement("canvas"))
);

function fileUploader($width, $height, $file, $callback) {
  
  function error(e) {  }
  
  // listener for the input@file onchange
  $file.addEventListener("change", function change() {  
    if(($file.files || []).length &&
    /^image\//.test((file = $file.files[0]).type)
   ) {
    var file = new FileReader;
    file.onload = function (e) {
      var fr = this;
      Resample(
        fr.result,
        $width || null,
        $height || null,
        false,
        function(dataURI){ // thumb
          Resample(fr.result,100,100,true,function(tDataURI){
          $callback(dataURI,tDataURI,$file.files[0].name);
        })}
      )
    };
  
    //file.onabort = abort;
    file.onerror = error;
    file.readAsDataURL($file.files[0]);
   }
  }, false);
 }