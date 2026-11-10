&glob DLL-LIB "mqic32.dll"
&glob CDECL CDECL

/*--------------------------------------------------------------------------
  Copyright (2000)
  ------------------------------------------------------------------------*/

/*********************************************************************/
/*  temp-table definition                                            */
/*********************************************************************/
{adapters/neogrid/include/anein102.i}
{adapters/neogrid/include/anein103.i}
{adapters/neogrid/include/anein105.i}

/*********************************************************************/
/* AS PROCEDURES A SEGUIR SAO PROCEDURES DE USO INTERNO              */
/* E NAO DEVEM SER CHAMADAS POR NENHUM OUTRO PROGRAMA                */
/*********************************************************************/
procedure MQCONN external {&DLL-LIB} {&CDECL}  PERSISTENT:
    def input        param QMgrName as char no-undo.  /* Name of queue manager */
    def output param Hconn    as long no-undo.  /* Connection handle */
    def output param CompCode as long no-undo.  /* Completion code */
    def output param Reason   as long no-undo.  /* Reason code qualifying CompCode */
end procedure.

procedure MQOPEN external {&DLL-LIB} {&CDECL} PERSISTENT:
    def input        param Hconn     as long   no-undo.  /* Connection handle */
    def input-output param pObjDesc  as memptr no-undo.  /* Object descriptor */
    def input        param Options   as long   no-undo.  /* Options that control the action of MQOPEN */
    def output       param Hobj      as long no-undo.    /* Object handle */
    def output       param CompCode  as long no-undo.    /* Completion code */
    def output       param Reason    as long no-undo.    /* Reason code qualifying CompCode */
end procedure.

procedure MQPUT external {&DLL-LIB} {&CDECL}  PERSISTENT:
    def input param Hconn               as long no-undo.   /* Connection handle */
    def input param Hobj                as long no-undo.   /* Object handle */
    def input-output param pMsgDesc     as memptr no-undo. /* Message descriptor */
    def input-output param pPutMsgOpts  as memptr no-undo. /* Options that control the action of MQPUT */
    def input param BufferLength        as long no-undo.   /* Length of the message in Buffer */
    def input param pBuffer             as long no-undo.   /* Message data */
    def output param CompCode           as long no-undo.   /* Completion code */
    def output param Reason             as long no-undo.   /* Reason code qualifying CompCode */
end procedure.

procedure MQGET external {&DLL-LIB} {&CDECL}  PERSISTENT:
    def input param Hconn               as long no-undo.   /* Connection handle */
    def input param Hobj                as long no-undo.   /* Object handle */
    def input-output param pMsgDesc     as memptr no-undo. /* Message descriptor */
    def input-output param pGetMsgOpts  as memptr no-undo. /* Options that control the action of MQGET */
    def input param BufferLength        as long no-undo.   /* Length in bytes of the Buffer area */
    def output param pBuffer            as memptr no-undo. /* Area to contain the message data */
    def output param DataLength         as long no-undo.   /* Length of the message */
    def output param CompCode           as long no-undo.   /* Completion code */
    def output param Reason             as long no-undo.   /* Reason code qualifying CompCode */
end procedure.

procedure MQCLOSE external {&DLL-LIB} {&CDECL} PERSISTENT:
    def input        param Hconn     as long no-undo.    /* Connection handle */
    def input-output param Hobj      as long no-undo.    /* Object handle */
    def input        param Options   as long no-undo.    /* Options that control the action of MQCLOSE */
    def output       param CompCode  as long no-undo.    /* Completion code */
    def output       param Reason    as long no-undo.    /* Reason code qualifying CompCode */
end procedure.

procedure MQDISC external {&DLL-LIB} {&CDECL} PERSISTENT:
    def input-output param Hconn    as long no-undo.  /* Connection handle */
    def output       param CompCode as long no-undo.  /* Completion code */
    def output       param Reason   as long no-undo.  /* Reason code qualifying CompCode */
end procedure.

procedure MQBEGIN external {&DLL-LIB} {&CDECL} PERSISTENT:
    def input param Hconn as long no-undo.              /* Connection handle */
    def input-output param pBeginOptions as memptr no-undo.  /* Options that control the action of MQBEGIN */
    def output param CompCode as long   no-undo.  /* Completion code */
    def output param Reason   as long   no-undo.  /* Reason code qualifying CompCode */
end procedure.

procedure MQCMIT external {&DLL-LIB} {&CDECL} PERSISTENT:
    define input param Hconn     as long.    /* Connection handle */
    define output param CompCode  as long.    /* Completion code */
    define output param Reason    as long.    /* Reason code qualifying CompCode */
end procedure.

procedure MQBACK external {&DLL-LIB} {&CDECL} PERSISTENT:
    define input param Hconn     as long.    /* Connection handle */
    define output param CompCode  as long.    /* Completion code */
    define output param Reason    as long.    /* Reason code qualifying CompCode */
end procedure.


/*********************************************************************/
/* AS PROCEDURES A SEGUIR SAO PROCEDURES DE USO EXTERNO              */
/* E DEVEM SER CHAMADAS PELOS PROGRAMAS                              */
/*********************************************************************/

/*********************************************************************/
/*  pi_MQCONN Function -- Connect Queue Manager                      */
/*********************************************************************/
procedure pi_MQCONN:
    def input  param QMgrName as char no-undo.  /* Name of queue manager */
    def output param Hconn    as int  no-undo.  /* Connection handle */
    def output param CompCode as int  no-undo.  /* Completion code */
    def output param Reason   as int  no-undo.  /* Reason code qualifying CompCode */
    
    run MQCONN(input QMgrName,
               output Hconn,
               output CompCode,
               output Reason).
end procedure.

/*********************************************************************/
/*  MQOPEN Function -- Open Object                                   */
/*********************************************************************/
procedure pi_MQOPEN:
    def input        param Hconn     as int    no-undo.  /* Connection handle */
    def input-output param table     for TT_MQOD.        /* Object descriptor */
    def input        param Options   as int    no-undo.  /* Options that control the action of MQOPEN */
    def output       param Hobj      as int    no-undo.  /* Object handle */
    def output       param CompCode  as int    no-undo.  /* Completion code */
    def output       param Reason    as int    no-undo.  /* Reason code qualifying CompCode */
    
    def var pObjDesc as memptr no-undo.
    
    run pi_writeMQOD (input-output table TT_MQOD,
                      output pObjDesc).
    
    run MQOPEN(input Hconn,
               input-output pObjDesc,
               input Options,
               output Hobj,
               output CompCode,
               output Reason).
    
    run pi_readMQOD(input-output table TT_MQOD,
                    input pObjDesc).
end procedure.

/*********************************************************************/
/*  MQPUT Function -- Put Message                                    */
/*********************************************************************/
procedure pi_MQPUT:
    def input param Hconn               as int  no-undo.   /* Connection handle */
    def input param Hobj                as int  no-undo.   /* Object handle */
    def input-output param table        for TT_MQMD.       /* Message descriptor */
    def input-output param table        for TT_MQPMO.      /* Options that control the action of MQPUT */
    def input param BufferLength        as int  no-undo.   /* Length of the message in Buffer */
    def input param pBuffer             as raw no-undo.   /* Message data */
    def output param CompCode           as int  no-undo.   /* Completion code */
    def output param Reason             as int  no-undo.   /* Reason code qualifying CompCode */
    
    def var pMsgDesc    as memptr no-undo.    
    def var pPutMsgOpts as memptr no-undo.
    def var pBufferaux  as memptr no-undo.
    def var icont       as int.

    set-size(pbufferaux) = 0.    
    set-size(pbufferaux) = length(pBuffer).    
    
    do iCont = 1 to length(pBuffer):
       put-byte(pbufferaux,icont) = get-byte(pBuffer,icont).
    end.        
            
    run pi_writeMQMD(input-output table TT_MQMD,
                     output pMsgDesc).
    
    run pi_writeMQPMO(input-output table TT_MQPMO,
                      output pPutMsgOpts).

    run MQPUT (input Hconn,
               input Hobj,
               input-output pMsgDesc,
               input-output pPutMsgOpts,
               input BufferLength,
               input get-pointer-value(pBufferaux),
               output CompCode,
               output Reason).
    
    run pi_readMQMD(input-output table TT_MQMD,
                    input pMsgDesc).
    
    run pi_readMQPMO(input-output table TT_MQPMO,
                     input pPutMsgOpts).
                     
    set-size(pbufferaux) = 0.
    set-size(pPutMsgOpts) = 0.
    set-size(pMsgDesc) = 0.                      
    
end procedure.

/*********************************************************************/
/*  MQPUT_CHAR Function -- Put Character Message                     */
/*********************************************************************/
procedure pi_MQPUT_CHAR:
    def input param Hconn               as int  no-undo.   /* Connection handle */
    def input param Hobj                as int  no-undo.   /* Object handle */
    def input-output param table        for TT_MQMD.       /* Message descriptor */
    def input-output param table        for TT_MQPMO.      /* Options that control the action of MQPUT */
    def input param  table for tt-msg-xml.                 /* Message data */
    def output param CompCode           as int  no-undo.   /* Completion code */
    def output param Reason             as int  no-undo.   /* Reason code qualifying CompCode */
    
    def var pMsgDesc    as memptr no-undo.    
    def var pPutMsgOpts as memptr no-undo.
    def var pBufferAux  as memptr no-undo.
    def var icont       as int.
    def var i-tamanho   as int.
       
    for each tt-msg-xml:
        assign i-tamanho = i-tamanho + length(tt-msg-xml.conteudo).
    end.
    
    set-size(pBufferAux) = i-tamanho + 1.
    assign i-tamanho = 0.
    
    for each tt-msg-xml:
        put-string(pBufferAux,i-tamanho + 1) = tt-msg-xml.conteudo. 
        assign i-tamanho = i-tamanho + length(tt-msg-xml.conteudo).        
        delete tt-msg-xml.
    end.
            
    run pi_writeMQMD(input-output table TT_MQMD,
                     output pMsgDesc).
    
    run pi_writeMQPMO(input-output table TT_MQPMO,
                      output pPutMsgOpts).

    run MQPUT (input Hconn,
               input Hobj,
               input-output pMsgDesc,
               input-output pPutMsgOpts,
               input (get-size(pBufferAux) - 1),
               input get-pointer-value(pBufferAux),
               output CompCode,
               output Reason).
    
    run pi_readMQMD(input-output table TT_MQMD,
                    input pMsgDesc).
    
    run pi_readMQPMO(input-output table TT_MQPMO,
                     input pPutMsgOpts).

    set-size(pBufferAux) = 0.
    set-size(pPutMsgOpts) = 0.
    set-size(pMsgDesc) = 0.                      
    
end procedure.

/*********************************************************************/
/*  MQGET Function -- Get Message                                    */
/*********************************************************************/
procedure pi_MQGET:
    def input param Hconn               as int  no-undo.   /* Connection handle */
    def input param Hobj                as int  no-undo.   /* Object handle */
    def input-output param table for TT_MQMD.              /* Message descriptor */
    def input-output param table for TT_MQGMO.             /* Options that control the action of MQGET */
    def input param BufferLength        as int  no-undo.   /* Length in bytes of the Buffer area */
    def output param pBuffer            as raw  no-undo.   /* Area to contain the message data */
    def output param DataLength         as int  no-undo.   /* Length of the message */
    def output param CompCode           as int  no-undo.   /* Completion code */
    def output param Reason             as int  no-undo.   /* Reason code qualifying CompCode */
    
    def var pMsgDesc as memptr no-undo.
    def var pGetMsgOpts as memptr no-undo.
    def var pBufferGet as memptr no-undo.
    def var pbuffergetaux as char.
    def var iCont      as int.
    
    run pi_writeMQMD(input-output table TT_MQMD,
                     output pMsgDesc).
    
    run pi_writeMQGMO(input-output table TT_MQGMO,
                      output pGetMsgOpts).
                      
    set-size(pBufferGet) = BufferLength + 1.
          
    run MQGET(input Hconn,
              input Hobj,
              input-output pMsgDesc,
              input-output pGetMsgOpts,
              input BufferLength,
              output pBufferGet,
              output DataLength,
              output CompCode,
              output Reason).
    
    run pi_readMQMD(input-output table TT_MQMD,
                    input pMsgDesc).
    run pi_readMQGMO(input-output table TT_MQGMO,
                    input pGetMsgOpts).
    
    do iCont = 1 to (if   TT_MQMD.FEEDBACK = 0  
                     then TT_MQMD.OriginalLength
                     else 100):
       assign put-byte(pBuffer,iCont) = get-byte(pBufferGet,iCont).
    end.  
    
    set-size(pBufferGet) = 0.    
    set-size(pMsgDesc) = 0.
    set-size(pGetMsgOpts) = 0.                      
end procedure.

/*********************************************************************/
/*  MQGET_CHAR Function -- Get Character Message                     */
/*********************************************************************/
procedure pi_MQGET_CHAR:

    def input param Hconn               as int  no-undo.   /* Connection handle */
    def input param Hobj                as int  no-undo.   /* Object handle */
    def input-output param table for TT_MQMD.              /* Message descriptor */
    def input-output param table for TT_MQGMO.             /* Options that control the action of MQGET */    
    def output param table for tt-msg-xml.                 /* Message data */
    def output param DataLength         as int  no-undo.   /* Length of the message */
    def output param CompCode           as int  no-undo.   /* Completion code */
    def output param Reason             as int  no-undo.   /* Reason code qualifying CompCode */
    
    def var pMsgDesc as memptr no-undo.
    def var pGetMsgOpts as memptr no-undo.
    def var pBufferGet as memptr no-undo.
    def var pbuffergetaux as char.
    def var iCont      as int.
    def var iCont1     as int.
    def var i-tamanho  as int.
    def var i-tamanho1 as int.
    
    run pi_writeMQMD(input-output table TT_MQMD,
                     output pMsgDesc).
    
    run pi_writeMQGMO(input-output table TT_MQGMO,
                      output pGetMsgOpts).
                      
    set-size(pBufferGet) = 4000001.
          
    run MQGET(input Hconn,
              input Hobj,
              input-output pMsgDesc,
              input-output pGetMsgOpts,
              input 4000000, /* TAMANHO DA MENSAGEM */
              output pBufferGet,
              output DataLength,
              output CompCode,
              output Reason).
    
    run pi_readMQMD(input-output table TT_MQMD,
                    input pMsgDesc).
    run pi_readMQGMO(input-output table TT_MQGMO,
                    input pGetMsgOpts).
    

    for each tt-msg-xml:
        delete tt-msg-xml.
    end.
    
    assign iCont1 = 1
           i-tamanho = 0
           i-tamanho1 = 30000.
    
    if  DataLength > 30000 then do:
        
        if (DataLength - i-tamanho) < 30000 then
            assign i-tamanho1 = DataLength - i-tamanho.

        do while i-tamanho <= DataLength AND i-tamanho1 <> 0:
            create tt-msg-xml.
            assign tt-msg-xml.sequencia = iCont1 
                   tt-msg-xml.conteudo  = get-string(pBufferGet,(i-tamanho + 1),i-tamanho1)
                   iCont1 = iCont1 + 1
                   i-tamanho = i-tamanho + i-tamanho1.
            if (DataLength - i-tamanho) < 30000 then
                assign i-tamanho1 = DataLength - i-tamanho.
        end. 

    end.
    else do:
        create tt-msg-xml.
        assign tt-msg-xml.sequencia = 1 
               tt-msg-xml.conteudo  = get-string(pBufferGet, 1).
    end.

    set-size(pBufferGet) = 0.
    set-size(pMsgDesc) = 0.
    set-size(pGetMsgOpts) = 0.                      
    
end procedure.

/*********************************************************************/
/*  MQCLOSE Function -- Close Object                                 */
/*********************************************************************/
procedure pi_MQCLOSE:
    def input        param Hconn     as int no-undo.    /* Connection handle */
    def input-output param Hobj      as int no-undo.    /* Object handle */
    def input        param Options   as int no-undo.    /* Options that control the action of MQCLOSE */
    def output       param CompCode  as int no-undo.    /* Completion code */
    def output       param Reason    as int no-undo.    /* Reason code qualifying CompCode */
    
    run MQCLOSE(input Hconn,
                input-output Hobj,
                input Options,
                output CompCode,
                output Reason).
end procedure.

/*********************************************************************/
/*  MQDISC Function -- Disconnect Queue Manager                      */
/*********************************************************************/
procedure pi_MQDISC:
    def input-output param Hconn    as int no-undo.  /* Connection handle */
    def output       param CompCode as int no-undo.  /* Completion code */
    def output       param Reason   as int no-undo.  /* Reason code qualifying CompCode */
    
    run MQDISC(input-output Hconn,
               output CompCode,
               output Reason).
end procedure.

/*********************************************************************/
/*  MQBEGIN Function -- Begin Unit of Work                           */
/*********************************************************************/
procedure pi_MQBEGIN:
    def input  param Hconn    as int  no-undo.  /* Connection handle */
    def input-output param table for TT_MQBO.   /* Options that control the action of MQBEGIN */
    def output param CompCode as int  no-undo.  /* Completion code */
    def output param Reason   as int  no-undo.  /* Reason code qualifying CompCode */

    def var pBeginOptions as memptr no-undo.
    
    run pi_writeMQBO(input-output table TT_MQBO,
                     output pBeginOptions).
    
    run MQBEGIN(input Hconn,
                input-output pBeginOptions,
                output CompCode,
                output Reason).
    
    run pi_readMQBO(input-output table TT_MQBO,
                    input pBeginOptions).

    set-size(pBeginOptions) = 0.                    
                    
end procedure.

/*********************************************************************/
/*  MQCMIT Function -- Commit Changes                                */
/*********************************************************************/
procedure pi_MQCMIT:
    define input  param Hconn     as int.    /* Connection handle */
    define output param CompCode  as int.    /* Completion code */
    define output param Reason    as int.    /* Reason code qualifying CompCode */
    
    run MQCMIT(input  Hconn,
               output CompCode,
               output Reason).
end procedure.

/*********************************************************************/
/*  MQBACK Function -- Commit Changes                                */
/*********************************************************************/
procedure pi_MQBACK:
    define input  param Hconn     as int.    /* Connection handle */
    define output param CompCode  as int.    /* Completion code */
    define output param Reason    as int.    /* Reason code qualifying CompCode */
    
    run MQBACK(input  Hconn,
               output CompCode,
               output Reason).
end procedure.

/*********************************************************************/
/* AS PROCEDURES A SEGUIR SAO PROCEDURES DE USO INTERNO              */
/* E NAO DEVEM SER CHAMADAS POR NENHUM OUTRO PROGRAMA                */
/*********************************************************************/
procedure pi_writeMQOD:
    def input-output param table     for TT_MQOD.
    def output param pObjDesc as memptr no-undo.
    
    set-size(pObjDesc) = {&MQOD_CURRENT_LENGTH}.
    
    find first TT_MQOD no-lock.
    
    TT_MQOD.StructId = substring(TT_MQOD.StructId + "    ", 1, 4).
    put-byte(pObjDesc, {&MQOD_StructId} + 0) = asc(substring(TT_MQOD.StructId, 1, 1)).
    put-byte(pObjDesc, {&MQOD_StructId} + 1) = asc(substring(TT_MQOD.StructId, 2, 1)).
    put-byte(pObjDesc, {&MQOD_StructId} + 2) = asc(substring(TT_MQOD.StructId, 3, 1)).
    put-byte(pObjDesc, {&MQOD_StructId} + 3) = asc(substring(TT_MQOD.StructId, 4, 1)).
    
    put-long(pObjDesc, {&MQOD_Version}) = TT_MQOD.Version.
    put-long(pObjDesc, {&MQOD_ObjectType}) = TT_MQOD.ObjectType.
    put-string(pObjDesc, {&MQOD_ObjectName}) = TT_MQOD.ObjectName.
    put-string(pObjDesc, {&MQOD_ObjectQMgrName}) = TT_MQOD.ObjectQMgrName.
    put-string(pObjDesc, {&MQOD_DynamicQName}) = TT_MQOD.DynamicQName.
    put-string(pObjDesc, {&MQOD_AlternateUserId}) = TT_MQOD.AlternateUserId.
    put-long(pObjDesc, {&MQOD_RecsPresent}) = TT_MQOD.RecsPresent.
    put-long(pObjDesc, {&MQOD_KnownDestCount}) = TT_MQOD.KnownDestCount.
    put-long(pObjDesc, {&MQOD_UnknownDestCount}) = TT_MQOD.UnknownDestCount.
    put-long(pObjDesc, {&mqod_invaliddestcount}) = TT_MQOD.InvalidDestCount.
    put-long(pObjDesc, {&MQOD_ObjectRecOffset}) = TT_MQOD.ObjectRecOffset.
    put-long(pObjDesc, {&MQOD_ResponseRecOffset}) = TT_MQOD.ResponseRecOffset.
    put-long(pObjDesc, {&MQOD_ObjectRecPtr}) = TT_MQOD.ObjectRecPtr.
    put-long(pObjDesc, {&MQOD_ResponseRecPtr}) = TT_MQOD.ResponseRecPtr.
end procedure.

procedure pi_readMQOD:
    def input-output param table     for TT_MQOD.
    def input param pObjDesc as memptr no-undo.
    
    for each TT_MQOD exclusive-lock:
        delete TT_MQOD.
    end.
    create TT_MQOD.
    
    assign  TT_MQOD.StructId = chr(get-byte(pObjDesc, {&MQOD_StructId} + 0))
                             + chr(get-byte(pObjDesc, {&MQOD_StructId} + 1))
                             + chr(get-byte(pObjDesc, {&MQOD_StructId} + 2))
                             + chr(get-byte(pObjDesc, {&MQOD_StructId} + 3))
            TT_MQOD.Version           = get-long(pObjDesc, {&MQOD_Version})
            TT_MQOD.ObjectType        = get-long(pObjDesc, {&MQOD_ObjectType})
            TT_MQOD.ObjectName        = get-string(pObjDesc, {&MQOD_ObjectName})
            TT_MQOD.ObjectQMgrName    = get-string(pObjDesc, {&MQOD_ObjectQMgrName})
            TT_MQOD.DynamicQName      = get-string(pObjDesc, {&MQOD_DynamicQName})
            TT_MQOD.AlternateUserId   = get-string(pObjDesc, {&MQOD_AlternateUserId})
            TT_MQOD.RecsPresent       = get-long(pObjDesc, {&MQOD_RecsPresent})
            TT_MQOD.KnownDestCount    = get-long(pObjDesc, {&MQOD_KnownDestCount})
            TT_MQOD.UnknownDestCount  = get-long(pObjDesc, {&MQOD_KnownDestCount})
            TT_MQOD.InvalidDestCount  = get-long(pObjDesc, {&mqod_invaliddestcount})
            TT_MQOD.ObjectRecOffset   = get-long(pObjDesc, {&MQOD_ObjectRecOffset})
            TT_MQOD.ResponseRecOffset = get-long(pObjDesc, {&MQOD_ResponseRecOffset})
            TT_MQOD.ObjectRecPtr      = get-long(pObjDesc, {&MQOD_ObjectRecPtr})
            TT_MQOD.ResponseRecPtr    = get-long(pObjDesc, {&MQOD_ResponseRecPtr}).
    set-size(pObjDesc) = 0.
end procedure.

/* ***************** */
procedure pi_writeMQMD:
    def input-output param table     for TT_MQMD.
    def output param pMsgDesc as memptr no-undo.
    
    def var iCont as int no-undo.
    
    find first TT_MQMD no-lock.
    set-size(pMsgDesc)    = {&MQMD_CURRENT_LENGTH}.
    
    TT_MQMD.StrucId = substring(TT_MQMD.StrucId + "    ", 1, 4).
    put-byte(pMsgDesc, {&MQMD_StrucId} + 0) = asc(substring(TT_MQMD.StrucId, 1, 1)).
    put-byte(pMsgDesc, {&MQMD_StrucId} + 1) = asc(substring(TT_MQMD.StrucId, 2, 1)).
    put-byte(pMsgDesc, {&MQMD_StrucId} + 2) = asc(substring(TT_MQMD.StrucId, 3, 1)).
    put-byte(pMsgDesc, {&MQMD_StrucId} + 3) = asc(substring(TT_MQMD.StrucId, 4, 1)).
    
    put-long(pMsgDesc, {&MQMD_Version}) = TT_MQMD.Version.
    put-long(pMsgDesc, {&MQMD_Report})  = TT_MQMD.Report.
    put-long(pMsgDesc, {&MQMD_MsgType}) = TT_MQMD.MsgType.
    put-long(pMsgDesc, {&MQMD_Expiry}) = TT_MQMD.Expiry.
    put-long(pMsgDesc, {&MQMD_Feedback}) = TT_MQMD.Feedback.
    put-long(pMsgDesc, {&MQMD_Encoding}) = TT_MQMD.Encoding.
    put-long(pMsgDesc, {&MQMD_CodedCharSetId}) = TT_MQMD.CodedCharSetId.
    put-string(pMsgDesc, {&MQMD_Format}) = TT_MQMD.FFormat.
    put-long(pMsgDesc, {&MQMD_Priority}) = TT_MQMD.Priority.
    put-long(pMsgDesc, {&MQMD_Persistence}) = TT_MQMD.Persistence.
    put-string(pMsgDesc, {&MQMD_MsgId}) = TT_MQMD.MsgId.
    put-string(pMsgDesc, {&MQMD_CorrelId}) = TT_MQMD.CorrelId.
    put-long(pMsgDesc, {&MQMD_BackoutCount}) = TT_MQMD.BackoutCount.
    put-string(pMsgDesc, {&MQMD_ReplyToQ}) = TT_MQMD.ReplyToQ.
    put-string(pMsgDesc, {&MQMD_ReplyToQMgr}) = TT_MQMD.ReplyToQMgr.
    put-string(pMsgDesc, {&MQMD_UserIdentifier}) = TT_MQMD.UserIdentifier.
    put-string(pMsgDesc, {&MQMD_AccountingToken}) = TT_MQMD.AccountingToken.
    put-string(pMsgDesc, {&MQMD_ApplIdentityData}) = TT_MQMD.ApplIdentityData.
    put-long(pMsgDesc, {&MQMD_PutApplType}) = TT_MQMD.PutApplType.
    put-string(pMsgDesc, {&MQMD_PutApplName}) = TT_MQMD.PutApplName.
    put-string(pMsgDesc, {&MQMD_PutDate}) = TT_MQMD.PutDat.
    put-string(pMsgDesc, {&MQMD_PutTime}) = TT_MQMD.PutTime.
    put-string(pMsgDesc, {&MQMD_ApplOriginData}) = TT_MQMD.ApplOriginData.
    put-string(pMsgDesc, {&MQMD_GroupId}) = TT_MQMD.GroupId.
    put-long(pMsgDesc, {&MQMD_MsgSeqNumber}) = TT_MQMD.MsgSeqNumber.
    put-long(pMsgDesc, {&MQMD_Offset}) = TT_MQMD.Offset.
    put-long(pMsgDesc, {&MQMD_MsgFlags}) = TT_MQMD.MsgFlags.
    put-long(pMsgDesc, {&MQMD_OriginalLength}) = TT_MQMD.OriginalLength.
end procedure.


procedure pi_readMQMD:
    def input-output param table for TT_MQMD.
    def input param pMsgDesc as memptr no-undo.
    
    def var iCont as int no-undo.
    
    for each TT_MQMD exclusive-lock:
        delete TT_MQMD.
    end.
    create TT_MQMD.
    
    assign TT_MQMD.StrucId = chr(get-byte(pMsgDesc, {&MQMD_StrucId} + 0))
                           + chr(get-byte(pMsgDesc, {&MQMD_StrucId} + 1))
                           + chr(get-byte(pMsgDesc, {&MQMD_StrucId} + 2))
                           + chr(get-byte(pMsgDesc, {&MQMD_StrucId} + 3))
           TT_MQMD.Version = get-long(pMsgDesc, {&MQMD_Version})
           TT_MQMD.Report = get-long(pMsgDesc, {&MQMD_Report})
           TT_MQMD.MsgType = get-long(pMsgDesc, {&MQMD_MsgType})
           TT_MQMD.Expiry = get-long(pMsgDesc, {&MQMD_Expiry})
           TT_MQMD.Feedback = get-long(pMsgDesc, {&MQMD_Feedback})
           TT_MQMD.Encoding = get-long(pMsgDesc, {&MQMD_Encoding})
           TT_MQMD.CodedCharSetId = get-long(pMsgDesc, {&MQMD_CodedCharSetId})
           TT_MQMD.Priority = get-long(pMsgDesc, {&MQMD_Priority})
           TT_MQMD.Persistence = get-long(pMsgDesc, {&MQMD_Persistence})
           TT_MQMD.BackoutCount = get-long(pMsgDesc, {&MQMD_BackoutCount})
           TT_MQMD.PutApplType = get-long(pMsgDesc, {&MQMD_PutApplType})
           TT_MQMD.MsgSeqNumber = get-long(pMsgDesc, {&MQMD_MsgSeqNumber})
           TT_MQMD.Offset = get-long(pMsgDesc, {&MQMD_Offset})
           TT_MQMD.MsgFlags = get-long(pMsgDesc, {&MQMD_MsgFlags})
           TT_MQMD.OriginalLength = get-long(pMsgDesc, {&MQMD_OriginalLength})
           TT_MQMD.FFormat = get-string(pMsgDesc, {&MQMD_Format}).
      /*** trantamento para MSGID ***/        
      do iCont = {&MQMD_MsgId} to {&MQMD_MsgId} + {&MQ_MSG_ID_LENGTH} - 1:
         assign TT_MQMD.MsgId = TT_MQMD.MsgId 
                                + (if iCont = {&MQMD_MsgId} then ""
                                   else ",") 
                                + STRING(get-byte(pMsgDesc,iCont)).           
      end.                      
      /*****************************/     
      
      assign
           
           TT_MQMD.CorrelId = get-string(pMsgDesc, {&MQMD_CorrelId})
           TT_MQMD.ReplyToQ = get-string(pMsgDesc, {&MQMD_ReplyToQ})
           TT_MQMD.ReplyToQMgr = get-string(pMsgDesc, {&MQMD_ReplyToQMgr})
           TT_MQMD.UserIdentifier = get-string(pMsgDesc, {&MQMD_UserIdentifier})
           TT_MQMD.AccountingToken = get-string(pMsgDesc, {&MQMD_AccountingToken})
           TT_MQMD.ApplIdentityData = get-string(pMsgDesc, {&MQMD_ApplIdentityData})
           TT_MQMD.PutApplName = get-string(pMsgDesc, {&MQMD_PutApplName})
           TT_MQMD.PutDat = get-string(pMsgDesc, {&MQMD_PutDate})
           TT_MQMD.PutTime = get-string(pMsgDesc, {&MQMD_PutTime})
           TT_MQMD.ApplOriginData = get-string(pMsgDesc, {&MQMD_ApplOriginData})
           TT_MQMD.GroupId = get-string(pMsgDesc, {&MQMD_GroupId}).
    set-size(pMsgDesc) = 0.
end procedure.
    
procedure pi_writeMQPMO:
    def input-output param table     for TT_MQPMO.
    def output param pPutMsgOpts     as memptr no-undo.
    
    def var iCont as int no-undo.

    find first TT_MQPMO no-lock.
    set-size(pPutMsgOpts) = {&MQPMO_CURRENT_LENGTH}.
    
    TT_MQPMO.StrucId = substring(TT_MQPMO.StrucId + "    ", 1, 4).
    put-byte(pPutMsgOpts, {&MQPMO_StrucId} + 0) = asc(substring(TT_MQPMO.StrucId, 1, 1)).
    put-byte(pPutMsgOpts, {&MQPMO_StrucId} + 1) = asc(substring(TT_MQPMO.StrucId, 2, 1)).
    put-byte(pPutMsgOpts, {&MQPMO_StrucId} + 2) = asc(substring(TT_MQPMO.StrucId, 3, 1)).
    put-byte(pPutMsgOpts, {&MQPMO_StrucId} + 3) = asc(substring(TT_MQPMO.StrucId, 4, 1)).
    
    put-long(pPutMsgOpts, {&MQPMO_Version}) = TT_MQPMO.Version.
    put-long(pPutMsgOpts, {&MQPMO_Options}) = TT_MQPMO.Options.
    put-long(pPutMsgOpts, {&MQPMO_Timeout}) = TT_MQPMO.Timeout.
    put-long(pPutMsgOpts, {&MQPMO_Context}) = TT_MQPMO.Context.
    put-long(pPutMsgOpts, {&MQPMO_KnownDestCount}) = TT_MQPMO.KnownDestCount.
    put-long(pPutMsgOpts, {&MQPMO_UnknownDestCount}) = TT_MQPMO.UnknownDestCount.
    put-long(pPutMsgOpts, {&mqpmo_invaliddestcount}) = TT_MQPMO.InvalidDestCount.
    put-string(pPutMsgOpts, {&MQPMO_ResolvedQName}) = TT_MQPMO.ResolvedQName.
    put-string(pPutMsgOpts, {&MQPMO_ResolvedQMgrName}) = TT_MQPMO.ResolvedQMgrName.
    put-long(pPutMsgOpts, {&MQPMO_RecsPresent}) = TT_MQPMO.RecsPresent.
    put-long(pPutMsgOpts, {&MQPMO_PutMsgRecFields}) = TT_MQPMO.PutMsgRecFields.
    put-long(pPutMsgOpts, {&MQPMO_PutMsgRecOffset}) = TT_MQPMO.PutMsgRecOffset.
    put-long(pPutMsgOpts, {&MQPMO_ResponseRecOffset}) = TT_MQPMO.ResponseRecOffset.
    put-long(pPutMsgOpts, {&MQPMO_PutMsgRecPtr}) = TT_MQPMO.PutMsgRecPtr.
    put-long(pPutMsgOpts, {&MQPMO_ResponseRecPtr}) = TT_MQPMO.ResponseRecPtr.
end procedure.

procedure pi_readMQPMO:
    def input-output param table for TT_MQPMO.
    def input param pPutMsgOpts as memptr no-undo.
    
    def var iCont as int no-undo.
    
    for each TT_MQPMO exclusive:
        delete TT_MQPMO.
    end.
    create TT_MQPMO.
    
    assign TT_MQPMO.StrucId = chr(get-byte(pPutMsgOpts, {&MQPMO_StrucId} + 0))
                            + chr(get-byte(pPutMsgOpts, {&MQPMO_StrucId} + 1))
                            + chr(get-byte(pPutMsgOpts, {&MQPMO_StrucId} + 2))
                            + chr(get-byte(pPutMsgOpts, {&MQPMO_StrucId} + 3))
           TT_MQPMO.Version = get-long(pPutMsgOpts, {&MQPMO_Version})
           TT_MQPMO.Options = get-long(pPutMsgOpts, {&MQPMO_Options})
           TT_MQPMO.Timeout = get-long(pPutMsgOpts, {&MQPMO_Timeout})
           TT_MQPMO.Context = get-long(pPutMsgOpts, {&MQPMO_Context})
           TT_MQPMO.KnownDestCount = get-long(pPutMsgOpts, {&MQPMO_KnownDestCount})
           TT_MQPMO.UnknownDestCount = get-long(pPutMsgOpts, {&MQPMO_UnknownDestCount})
           TT_MQPMO.InvalidDestCount = get-long(pPutMsgOpts, {&mqpmo_invaliddestcount})
           TT_MQPMO.RecsPresent = get-long(pPutMsgOpts, {&MQPMO_RecsPresent})
           TT_MQPMO.PutMsgRecFields = get-long(pPutMsgOpts, {&MQPMO_PutMsgRecFields})
           TT_MQPMO.PutMsgRecOffset = get-long(pPutMsgOpts, {&MQPMO_PutMsgRecOffset})
           TT_MQPMO.ResponseRecOffset = get-long(pPutMsgOpts, {&MQPMO_ResponseRecOffset})
           TT_MQPMO.PutMsgRecPtr = get-long(pPutMsgOpts, {&MQPMO_PutMsgRecPtr})
           TT_MQPMO.ResponseRecPtr = get-long(pPutMsgOpts, {&MQPMO_ResponseRecPtr})
           TT_MQPMO.ResolvedQName = get-string(pPutMsgOpts, {&MQPMO_ResolvedQName})
           TT_MQPMO.ResolvedQMgrName = get-string(pPutMsgOpts, {&MQPMO_ResolvedQMgrName}).
    set-size(pPutMsgOpts) = 0.
end.

procedure pi_writeMQGMO:
    def input-output param table     for TT_MQGMO.
    def output param pGetMsgOpts     as memptr no-undo.
    
    def var iCont as int no-undo.
    
    find first TT_MQGMO no-lock.
    set-size(pGetMsgOpts) = {&MQGMO_CURRENT_LENGTH}.

    TT_MQGMO.StrucId = substring(TT_MQGMO.StrucId + "    ", 1, 4).
    put-byte(pGetMsgOpts, {&MQGMO_StrucId} + 0) = asc(substring(TT_MQGMO.StrucId, 1, 1)).
    put-byte(pGetMsgOpts, {&MQGMO_StrucId} + 1) = asc(substring(TT_MQGMO.StrucId, 2, 1)).
    put-byte(pGetMsgOpts, {&MQGMO_StrucId} + 2) = asc(substring(TT_MQGMO.StrucId, 3, 1)).
    put-byte(pGetMsgOpts, {&MQGMO_StrucId} + 3) = asc(substring(TT_MQGMO.StrucId, 4, 1)).
    
    put-long(pGetMsgOpts, {&MQGMO_Version}) = TT_MQGMO.Version.
    put-long(pGetMsgOpts, {&MQGMO_Options}) = TT_MQGMO.Options.
    put-long(pGetMsgOpts, {&MQGMO_WaitInterval}) = TT_MQGMO.WaitInterval.
    put-long(pGetMsgOpts, {&MQGMO_Signal1}) = TT_MQGMO.Signal1.
    put-long(pGetMsgOpts, {&MQGMO_Signal2}) = TT_MQGMO.Signal2.
    put-long(pGetMsgOpts, {&MQGMO_MatchOptions}) = TT_MQGMO.MatchOptions.
    put-byte(pGetMsgOpts, {&MQGMO_GroupStatus}) = asc(TT_MQGMO.GroupStatus).
    put-byte(pGetMsgOpts, {&MQGMO_SegmentStatus}) = asc(TT_MQGMO.SegmentStatus).
    put-byte(pGetMsgOpts, {&MQGMO_Segmentation}) = asc(TT_MQGMO.Segmentation).
    put-byte(pGetMsgOpts, {&MQGMO_Reserved1}) = asc(TT_MQGMO.Reserved1).
    put-string(pGetMsgOpts, {&MQGMO_ResolvedQName}) = TT_MQGMO.ResolvedQName.
end procedure.

procedure pi_readMQGMO:
    def input-output param table for TT_MQGMO.
    def input param pGetMsgOpts as memptr no-undo.
    
    def var iCont as int no-undo.
    
    for each TT_MQGMO exclusive-lock:
        delete TT_MQGMO.
    end.
    create TT_MQGMO.
    
    assign TT_MQGMO.StrucId = chr(get-byte(pGetMsgOpts, {&MQGMO_StrucId} + 0))
                            + chr(get-byte(pGetMsgOpts, {&MQGMO_StrucId} + 1))
                            + chr(get-byte(pGetMsgOpts, {&MQGMO_StrucId} + 2))
                            + chr(get-byte(pGetMsgOpts, {&MQGMO_StrucId} + 3))
           TT_MQGMO.Version = get-long(pGetMsgOpts, {&MQGMO_Version})
           TT_MQGMO.Options = get-long(pGetMsgOpts, {&MQGMO_Options})
           TT_MQGMO.WaitInterval = get-long(pGetMsgOpts, {&MQGMO_WaitInterval})
           TT_MQGMO.Signal1 = get-long(pGetMsgOpts, {&MQGMO_Signal1})
           TT_MQGMO.Signal2 = get-long(pGetMsgOpts, {&MQGMO_Signal2})
           TT_MQGMO.MatchOptions = get-long(pGetMsgOpts, {&MQGMO_MatchOptions})
           TT_MQGMO.GroupStatus = chr(get-byte(pGetMsgOpts, {&MQGMO_GroupStatus}))
           TT_MQGMO.SegmentStatus = chr(get-byte(pGetMsgOpts, {&MQGMO_SegmentStatus}))
           TT_MQGMO.Segmentation = chr(get-byte(pGetMsgOpts, {&MQGMO_Segmentation}))
           TT_MQGMO.Reserved1 = chr(get-byte(pGetMsgOpts, {&MQGMO_Reserved1}))
           TT_MQGMO.ResolvedQName = get-string(pGetMsgOpts, {&MQGMO_ResolvedQName}).
    
    set-size(pGetMsgOpts) = 0.
end procedure.

procedure pi_writeMQBO:
    def input-output param table for TT_MQBO.
    def output param pBeginOptions as memptr no-undo.
    
    find first TT_MQBO no-lock.
    set-size(pBeginOptions) = {&MQBO_CURRENT_LENGTH}.

    TT_MQBO.StrucId = substring(TT_MQBO.StrucId + "    ", 1, 4).
    put-byte(pBeginOptions, {&MQBO_StrucId} + 0) = asc(substring(TT_MQBO.StrucId, 1, 1)).
    put-byte(pBeginOptions, {&MQBO_StrucId} + 1) = asc(substring(TT_MQBO.StrucId, 2, 1)).
    put-byte(pBeginOptions, {&MQBO_StrucId} + 2) = asc(substring(TT_MQBO.StrucId, 3, 1)).
    put-byte(pBeginOptions, {&MQBO_StrucId} + 3) = asc(substring(TT_MQBO.StrucId, 4, 1)).
    
    put-long(pBeginOptions, {&MQBO_Version}) = TT_MQBO.Version.
    put-long(pBeginOptions, {&MQBO_Options}) = TT_MQBO.Options.
end procedure.

procedure pi_readMQBO:
    def input-output param table for TT_MQBO.
    def input param pBeginOptions as memptr no-undo.
    
    for each TT_MQBO exclusive-lock:
        delete TT_MQBO.
    end.
    create TT_MQBO.
    assign TT_MQBO.StrucId = chr(get-byte(pBeginOptions, {&MQBO_StrucId} + 0))
                           + chr(get-byte(pBeginOptions, {&MQBO_StrucId} + 1))
                           + chr(get-byte(pBeginOptions, {&MQBO_StrucId} + 2))
                           + chr(get-byte(pBeginOptions, {&MQBO_StrucId} + 3))
           TT_MQBO.Version = get-long(pBeginOptions, {&MQBO_Version})
           TT_MQBO.Options = get-long(pBeginOptions, {&MQBO_Options}).
end procedure.

