@include = ->
  @client '/commentTemplate.js': ->
    window.commentTemplate = (id) ->
      article = document.createElement("article")
      header = document.createElement("header")
      h3 = document.createElement("h3")
      time = document.createElement("time")
      div = document.createElement("div")
      p = document.createElement("p")
      clear = document.createElement("div")
      article.id=id
      article.appendChild(header)
      article.appendChild(div)
      article.appendChild(clear)
      header.appendChild(h3)
      header.appendChild(time)
      div.className="body"
      div.appendChild(p)
      h3.className="edit"
      h3.innerHTML = "Name..."
      p.className="left edit"
      p.innerHTML = "Comment..."
      d = new Date()
      mmm = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
      dd = d.getDate() + " " + mmm[d.getMonth()] + " " + d.getFullYear().toString().substr(2) + " " + ('0' + d.getHours()).slice(-2) + ":" + ('0' + d.getMinutes()).slice(-2)
      time.innerHTML = dd
      header.setAttribute('data-time',dd)
      clear.className="clear"
      return article
