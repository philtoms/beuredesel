@include = ->
  @onSave = (data, a, d) ->
     d.headerImg = data.headerImg if data.headerImg

  @client '/article.js': ->
    window.articleTemplate = (id) ->
      article = document.createElement("article")
      header = document.createElement("header")
      h2 = document.createElement("h2")
      time = document.createElement("time")
      div = document.createElement("div")
      p = document.createElement("p")
      clear = document.createElement("div")
      article.id=id
      article.appendChild(header)
      article.appendChild(div)
      article.appendChild(clear)
      header.appendChild(h2)
      header.appendChild(time)
      div.className="body"
      div.appendChild(p)
      h2.className="edit"
      h2.innerHTML = "Title..."
      p.className="left edit"
      p.innerHTML = "Article..."
      d = new Date()
      header.setAttribute('data-time',d.toDateString())
      mmm = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
      time.innerHTML = d.getDate() + " " + mmm[d.getMonth()] + " " + d.getFullYear().toString().substr(2)
      clear.className="clear"
      return article

    window.onSave = (id,issueNo) ->
      $("header h1").text "Issue No "+issueNo
      
    window.onUpload = (article,fileName) ->
      img = "<img class='edit' src='/images/gallery/{name}' />".replace(/{name}/g,fileName)
      $(".body",article).prepend(img)

