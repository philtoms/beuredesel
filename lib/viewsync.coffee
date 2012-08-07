@include = ->
  @include('templates/articleTemplate')
  fs = require('fs')
  #rename = require('fs').rename
  #gm = require('gm')

  @viewsync = -> 
    '''
      head.ready(document,function(){
        head.js(
        'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js'
        ,function(){
          $('#scrapbook').click(function(e){
            if (e.ctrlKey){
              $('#scrapbook').unbind('click');
              head.js(
               '/socket.io/socket.io.js'
              ,'/zappa/zappa.js'
              ,'/viewsync.js'
              ,function(){
               //console.log("done");
              });
            }
          });
        });
      });
    '''

  root = @root
  store = @store
  appData = @appData
  
  @post '/login' : ->
    b = @request.body
    if appData.users[b.user] == b.pass
      @session.user = {admin:b.user}
    @send if @session.user?.admin then 'ok' else ''
      
  @post '/upload' : ->
    jpgName = (@body.path ? '') + @body.name.split('.')[0]+'.jpg'
    base64Data = @body.img.split(',')[1]
    tbase64Data = @body.thumb.split(',')[1]
    dest = root+'/public/images/'+jpgName
    tDest = root+'/public/images/thumbs/'+jpgName
    send = @send
    decodedImage = new Buffer(base64Data, 'base64')
    fs.writeFile dest, decodedImage, (err) ->
      if (err) 
        console.log(err)
      else
        console.log 'decoded ' + jpgName
        decodedImage = new Buffer(tbase64Data, 'base64')
        fs.writeFile tDest, decodedImage, ->
        send(jpgName)

    #file = @request.files.Filedata
    #dest = root+'/public/images/'+(@body.path ? '')+file.name
    #tDest = (root+'/public/images/thumbs/'+file.name).split('.')[0]+'.jpg'
    ##rename root+'/'+file.path, dest, ->
    #gm(root+'/'+file.path).thumb 300,0,dest, (err) ->
    #  gm(dest).thumb 100,100,tDest, (err) ->
    #    if (err) 
    #      console.log(err)
    #    else
    #      send('Success!')

  onSave = @onSave
  @on sync: ->
    data = @data
    id = data.id
    store.get id, (e,d,k) ->
#      if !d || d.article!=data.article
        (d ?={}).article = data.article
        d.date = data.date
        onSave data, appData, d
        store.save id,d,->
          appData.issueNo = data.issueNo
          store.save "app", appData, ->
            console.log "updated " + id
            if data.piclink
              store.get 'page/index/topten', (e,d,k) ->
                d.piclinks = d.piclinks.filter (x) -> x.link!=data.piclink.link
                d.piclinks.unshift data.piclink
                store.save 'page/index/topten',d, ->
                  console.log "piclinks updated " + data.piclink.title


  @client '/viewsync.js': ->
    io = this
    left = $(window).width() / 2 - 150
    top = $(window).height() / 2 - 60
    login = $("<form id='login'>
                 <label>Name<input name='user'/></label>
                 <label>Password<input type='password' name='pass'></label>
                 <label><input type='button' value='Submit'/><input type='button' value='Cancel'/></label>
               </form>").css({top:top,left:left}).appendTo('body')

    $("input[name='user']",login).focus()
    $("input[type='button']",login).click (e) ->
      if e.target.value=='Cancel'
        login.hide()
        return false

      $.post '/login', login.serialize(), (r) ->
        if r=='ok'
          login.hide()
          head.js(
            '/scripts/resample.js'
            ,'/articleTemplate.js'
            ,edit
          )
           
      return false
      
    edit = =>
      cmdBar = $("""<div id='cmdbar'>
      <input id='file_upload' name='file_upload' type='file'>
      <a href='#new'>New article</a>
      <a href='#save'>Save this article</a>
      <a href='#cancel'>Cancel</a>
      <label>Add to piclinks</label><input type='checkbox' id='piclink'/>
      </div>""")
      cmdBar.appendTo('body')
      
      @connect()

      savedRange=false
      saveSelection = ->
        if window.getSelection
          savedRange = window.getSelection().getRangeAt(0)
        else if document.selection #ie
          savedRange = document.selection.createRange()

      restoreSelection = (area) ->
        if !savedRange 
          area.focus()
          saveSelection()
        area.focus()
        if savedRange != null
          if window.getSelection
            s = window.getSelection()
            if s.rangeCount > 0 
                s.removeAllRanges()
            s.addRange(savedRange)
          else 
            if document.createRange
              window.getSelection().addRange(savedRange);
            else 
              if document.selection #ie
                savedRange.select()
                
        savedRange=false

      viewsync = new class

        fileUploader 600,0,$("#file_upload")[0],(img,thumb,name) =>
          xhr = new XMLHttpRequest()
          fd = new FormData()
          fd.append( 'img', img )
          fd.append( 'thumb', thumb )
          fd.append( 'name', name )
          fd.append('path','gallery/')
          xhr.open( 'POST', '/upload', true )
          xhr.onload =  -> 
            contentEdit true
            onUpload(article,name)
          xhr.send( fd )
             
        left=37
        up=38
        right=39
        down=40
        inEdit=false
        article=null
        articleDate=null
        section=null
        empty=''
        unchanged=''
        focusTag={}
        root=$('body')[0].id

        toggle: (e) ->
          if e.ctrlKey or inEdit

            e.preventDefault()

            focusTag[e.target.tagName]=$ e.target
            
            if e.ctrlKey && !inEdit
              saveSelection()
              article=$(e.target).closest('article')
              section = article.closest("section")
              unchanged = article.html()
              article.before cmdBar.show()
              contentEdit true
              inEdit=true;
              
        command: (e) ->
          switch e.target.href?.split('#')[1]
            when "save"
              id = article[0].id.replace(/-/g,'/')
              aIssueNo = parseInt(id.split('/').pop(),10)
              if aIssueNo>issueNo then issueNo=aIssueNo
              piclink=null
              if $('#piclink').prop("checked")
                piclink=
                  link:id.replace(/page\//g,'')
                  title:article.find("h2").text()
                  src:'images/thumbs/gallery/'+article.find("img")[0].src.split('/').pop()
              contentEdit false
              io.emit sync:
                id:id
                article:article.html()
                date:articleDate
                issueNo:aIssueNo
                piclink:piclink
              $('#piclink').prop("checked",false)
              window.onSave article[0].id,aIssueNo,piclink
              
            when "cancel"
              if article.html() == empty
                article.remove()
              else
                article.html(unchanged)
              contentEdit false          

            when "new"
              contentEdit false
              id = 'page-'+root+'-' + issueNo
              section.prepend articleTemplate id
              article = $("#"+id)
              article.before cmdBar.show()
              $('html, body').animate({scrollTop:article.offset().top,500}, =>
                  contentEdit true
                  empty = article.html()
              )

          return false;
          
        move: (e) ->
          if focusTag.IMG 
            float=false
            switch e.keyCode
              when left then float = {float:"left"}
              when right then float = {float:"right"}
              else focusTag={}
            if float
              focusTag.IMG.css(float).focus().click()
              e.preventDefault()
                
        contentEdit = (editable) ->
          edit = article.find(".edit")
          if editable
            edit.attr("contentEditable",true)
            articleDate = article.find("[data-time]").data("time");
            restoreSelection edit
          else
            edit.removeAttr("contentEditable")
            inEdit=false
            cmdBar.hide()

    #events
      $('article').click (e) -> viewsync.toggle e
      $('#cmdbar a').click (e) -> viewsync.command e
      $('body').keypress (e) -> viewsync.move e
      