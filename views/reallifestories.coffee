@title = 'LJS - Real Life Stories'
@longtitle = 'Real life stories from the kerbside'
@description = 'Stories about the life of a mobile mechanic out and about around Swadlincote and the east midlands area'

@stylesheets = [
  '/scripts/uploadify/uploadify'
  {inline:'''
    section {width:600px;font-size:1.3em;}
    article header {padding:5px 0;}
    article a {font-size:1em;}
    article p {padding-bottom:10px;}
    article img {float:right;width:250px;padding:5px;}
  '''}
]
@scripts = [
  '/scripts/uploadify/jquery.uploadify.min'
  '/scripts/uploadify/swfobject'
  './viewsync'
  {inline:'''
    articleTemplate = function(id){
      var article = document.createElement("article");
      var header = document.createElement("header");
      var h2 = document.createElement("h2");
      var p = document.createElement("p");
      article.id=id;
      h2.innerHTML="Title...";
      p.innerHTML = "Article...";
      article.appendChild(header)
      article.appendChild(p)
      header.appendChild(h2)
      return article
    }
    onUpload=function(article,fileName){
      img = "<img src='/images/gallery/{name}' />".replace(/{name}/g,fileName);
      $("h2",article).after(img);
    }
  '''}
]

for x of @data
  article id:x.split('/')[1], ->
    @data[x].article