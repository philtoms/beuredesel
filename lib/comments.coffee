@include = ->
  @include('templates/commentTemplate')

  @comments = -> 
    '''
      head.ready(document,function(){
        head.js(
        '/googlea.js'
        ,'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js'
        ,function(){
          $('#cmdbar').show().click(function(e){
              if ((e.target.href ||"").split('#')[1]=="add"){
                head.js(
                 '/socket.io/socket.io.js'
                ,'/zappa/zappa.js'
                ,'/comments.js'
                ,'../commentTemplate.js'
                ,function(){edit();}
                );
              }
          });
        });
      });
    '''

  root=@root
  store = @store
  appData=@appData
  
  @on comment: ->
    data = @data
    id = data.id.replace(/-/g,'/')
    data.comment.checked=false
    store.get id, (e,d,k) ->
      if d
        c = d.comments || []
        c.push(data.comment)
        d.comments = c
        store.save id,d,->
          console.log "updated comments" + id

  @client '/comments.js': ->
    io = this
      
    window.edit = =>
      $('#cmdbar').html("<a href='#save'>Post this comment</a><a href='#cancel'>Cancel</a>");

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

      comments = new class

        comment=null
        section=null
        root=$('body')[0].id

        command: (e) ->
          switch e.target.href?.split('#')[1]

            when "save"
              io.emit comment: {
                id:id,
                comment:{
                  name:comment.find("h3").text(),
                  text:comment.find(".body .edit").html(),
                  date:comment.find("time").text()
                }
              }
              contentEdit false              
              
            when "cancel"
              comment.remove()
              contentEdit false          

          return false;
          
        contentEdit = (editable) ->
          edit = comment.find(".edit")
          if editable
            edit.attr("contentEditable",true)
            restoreSelection edit[0]
          else
            edit.removeAttr("contentEditable")
            inEdit=false
            $('#cmdbar').hide()

        id = $("#articles article")[0].id
        $("#commentry").prepend commentTemplate "new"
        comment = $("#new")
        comment.keydown (e) ->
          t=e.target.innerHTML
          if t=="Name..." || t=="Comment..."
            e.target.innerHTML=""
        contentEdit true

    #events
      $('#cmdbar a').click (e) -> comments.command e
      
      