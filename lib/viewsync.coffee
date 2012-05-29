@include = ->
  @include('articleTemplate')
  rename = require('fs').rename
  gm = require('gm')

  @on 'connection': ->
    console.log 'connect' 

  @viewsync = -> 
    '''
      head.ready(document,function(){
        head.js(
        '/googlea.js'
        ,'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js'
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

  root=@root
  appData=@data
  
  @post '/login' : ->
    b = @request.body
    @send if appData.users[b.user] == b.pass then 'ok' else ''
      
  @post '/upload' : ->
    file = @request.files.Filedata
    send = @send
    dest = root+'/public/images/'+(@body.path ? '')+file.name
    tDest = (root+'/public/images/thumbs/'+file.name).split('.')[0]+'.jpg'
    rename root+'/'+file.path, dest, ->
      gm(dest).thumb 80,80,tDest, (err) ->
        if (err) 
          console.log(err)
        else
          send('Success!')

  store = @model
  onSave = @onSave
  @on sync: ->
    data = @data
    id = data.id.replace(/-/g,'/')
    store.get id, (e,d,k) ->
      if !d || d.article!=data.article
        (d ?={}).article = data.article
        d.date = data.date
        onSave data, appData, d
        store.save id,d,->
          appData.issueNo = data.issueNo
          store.save "app", appData, ->
            console.log "updated " + id

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
             '/scripts/uploadify/jquery.uploadify.min.js'
            ,'/scripts/uploadify/swfobject.js'
            ,'/article.js'
            ,edit
          )
           
      return false
      
    edit = =>
      cmdBar = $("<div id='cmdbar'><input id='file_upload' name='file_upload' type='file'><a href='#new'>New article</a><a href='#save'>Save this article</a><a href='#cancel'>Cancel</a></div>");
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

        $('#file_upload').uploadify
          'uploader'  : '/scripts/uploadify/uploadify.swf'
          'script'    : '/upload'
          'cancelImg' : '/scripts/uploadify/cancel.png'
          'scriptData': 'path':'gallery/'
          'auto'      : true
          'onComplete':(event, ID, fileObj, response, data) ->
            contentEdit true
            onUpload(article,fileObj.name)
      
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
              contentEdit false
              io.emit sync: {id:article[0].id,article:article.html(),date:articleDate, issueNo:issueNo} 
              onSave article[0].id,issueNo
              
            when "cancel"
              if article.html() == empty
                article.remove()
              else
                article.html(unchanged)
              contentEdit false          

            when "new"
              contentEdit false
              id = 'page-'+root+'-' + (++issueNo)
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
      $('body').click (e) -> viewsync.toggle e
      $('#cmdbar').click (e) -> viewsync.command e
      $('body').keypress (e) -> viewsync.move e
      