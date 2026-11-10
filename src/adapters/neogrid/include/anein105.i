procedure ConnectQueueManager:

    def input param Manager as char no-undo.
    def output param Hconn as int no-undo.
    def output param CompCode as int no-undo.
    def output param Reason as int no-undo.
    
    run pi_MQCONN (input Manager,
                   output Hconn,
                   output CompCode,
                   output Reason).

end procedure.

procedure OpenQueueForRead:

    def input param Queue as char no-undo.
    def input param Hconn as int no-undo.
    def output param Hobj as int no-undo.
    def output param CompCode as int no-undo.
    def output param Reason as int no-undo.
    
    def var Options as int no-undo.
    
    for each TT_MQOD:
      delete TT_MQOD.
    end.  
    
    create TT_MQOD.
    assign Options =  {&MQOO_INPUT_AS_Q_DEF}
           TT_MQOD.OBJECTNAME = Queue.
    
    RUN pi_MQOPEN (input Hconn,
                   input-output table TT_MQOD,
                   input  Options,
                   output Hobj,
                   output CompCode,
                   output Reason).

end procedure.

procedure OpenQueueForWrite:

    def input param Queue as char no-undo.
    def input param Hconn as int no-undo.
    def output param Hobj as int no-undo.
    def output param CompCode as int no-undo.
    def output param Reason as int no-undo.
    
    def var Options as int no-undo.
    
    for each TT_MQOD:
      delete TT_MQOD.
    end.  
    
    create TT_MQOD.
    assign Options =  {&MQOO_OUTPUT}
           TT_MQOD.OBJECTNAME = Queue.
    
    RUN pi_MQOPEN (input Hconn,
                   input-output table TT_MQOD,
                   input  Options,
                   output Hobj,
                   output CompCode,
                   output Reason).

end procedure.

procedure SendMessage:

    def input param Hconn as int no-undo.
    def input param Hobj as int no-undo.
    def input param table for tt-msg-xml.                 /* Message data */
    def output param CompCode as int no-undo.
    def output param Reason as int no-undo.

    def var cont as int no-undo.
    def var ini as int no-undo.
    def var i as int no-undo.
    
    for each tt_mqmd:
      delete tt_mqmd.
    end.  
    
    create tt_mqmd.
    assign tt_mqmd.fformat = {&MQFMT_STRING}.
           /*tt_mqmd.MsgFlags = {&MQMF_SEGMENTATION_ALLOWED}*/
    
    for each tt_mqpmo.
      delete tt_mqpmo.
    end.  
    
    create tt_mqpmo.
/*    assign TT_MQPMO.Options = {&MQPMO_LOGICAL_ORDER}.*/
    
    RUN pi_MQPUT_CHAR (input Hconn,
                       input Hobj,
                       input-output table TT_MQMD,
                       input-output table TT_MQPMO,
                       input  table tt-msg-xml,
                       output CompCode,
                       output Reason).

end procedure.


procedure DisconnectQueueManager:

def input param Hconn as int.
def output param CompCode as int.
def output param Reason as int.

run pi_MQDISC (input-output Hconn,
               output CompCode,
               output Reason).

end procedure.

procedure CloseQueue:
    def input        param Hconn     as int no-undo.    /* Connection handle */
    def input        param Hobj      as int no-undo.    /* Object handle */
    def output       param CompCode  as int no-undo.    /* Completion code */
    def output       param Reason    as int no-undo.    /* Reason code qualifying CompCode */
    
    run pi_MQCLOSE(input Hconn,
                   input-output Hobj,
                   input 0,
                   output CompCode,
                   output Reason).
end procedure.

procedure ReadMessage:
    def input param Hconn as int no-undo.
    def input param Hobj as int no-undo.
    def output param table for tt-msg-xml.                 /* Message data */
    def output param CompCode as int no-undo.
    def output param Reason as int no-undo.
    
    def var DataLength as int no-undo.
    
    for each TT_MQMD:
      delete TT_MQMD.
    end.  

    create TT_MQMD.
/*    assign tt_mqmd.MsgFlags = {&MQMF_SEGMENTATION_ALLOWED}.*/
    
    for each TT_MQGMO:
      delete TT_MQGMO.
    end.  
                               
    create TT_MQGMO.
                            
    for each tt-msg-xml:
      delete tt-msg-xml.
    end.  
        
    RUN pi_MQGET_CHAR (input Hconn,
                       input Hobj,
                       input-output table TT_MQMD,
                       input-output table TT_MQGMO,         
                       output table tt-msg-xml,
                       output DataLength,
                       output CompCode,
                       output Reason).  
                       
      
end procedure.

procedure ConvertStringToRaw:

    def input param mesg as char no-undo.
    def output param mesg-raw as raw no-undo.
    
    output to "clipboard".
    put unformatted "~"" mesg "~"".
    output close.
    
    input from "clipboard".
    import mesg-raw.
    input close.
    
end procedure.
