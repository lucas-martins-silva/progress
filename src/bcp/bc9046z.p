/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9046Z 2.00.00.003 } /*** "010003" 09/10/2025 11:26:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9046Z MBC}
&ENDIF

{include/i_dbinst.i}

&IF '{&mgscm_version}' >= '2.062' &THEN

&GLOBAL-DEFINE ProgramName BC9046
&GLOBAL-DEFINE TempTable tt-confirma
&GLOBAL-DEFINE FrameSize 20 BY 8
&GLOBAL-DEFINE ErrorDisplaySeconds 3

{bcp/bc9046.i}
{scbo/bosc032.i tt-wm-box-movto}
{scbo/bosc038.i tt-wm-docto}
{scbo/bosc137.i ttWm-box-movto-lote}

DEFINE TEMP-TABLE tt-doctos NO-UNDO
    FIELD nr-docto  LIKE item-docto-transf-depos.num-docto-transf COLUMN-LABEL 'DOCTO'
    FIELD dat-docto LIKE wm-docto.dt-implan-docto                 COLUMN-LABEL 'DATA'
    INDEX idx-docto IS PRIMARY UNIQUE nr-docto.

DEFINE VARIABLE h-bosc038       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bosc032       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bosc137       AS HANDLE    NO-UNDO.
DEFINE VARIABLE i-registros     AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-sequencia-aux AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-elimina       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i-aux           AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-aux           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-aux2          AS CHARACTER NO-UNDO.

DEFINE BUFFER bf-tt-wm-box-movto FOR tt-wm-box-movto.

DEFINE QUERY qr-doctos FOR tt-doctos.

DEFINE BROWSE brw-confirma QUERY qr-doctos NO-LOCK
    DISPLAY tt-doctos.nr-docto WIDTH 5.5
            tt-doctos.dat-docto WIDTH 10.5
        WITH NO-BOX NO-LABELS SIZE 18 BY 4.5 NO-SCROLLBAR-VERTICAL.

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE tt-confirma.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttWork.

&GLOBAL-DEFINE Frame01Name Frame01
&GLOBAL-DEFINE Frame01Defs 'Conf. Transf. WMS'  AT ROW 01 COLUMN 01 ~
                           '------------------' AT ROW 02 COLUMN 01 ~
                           brw-confirma         AT ROW 03 COLUMN 01
&GLOBAL-DEFINE Frame01Repeat NO
&GLOBAL-DEFINE Update01Fields brw-confirma
&GLOBAL-DEFINE TriggerBeforeFrame01 RUN InicializaCamposFrame01. IF vLogSai THEN LEAVE _frame01.
&GLOBAL-DEFINE TriggerAfterFrame01  RUN GravaCamposFrame01. IF vLogFinaliza THEN LEAVE _frame01.

&GLOBAL-DEFINE UserTriggers ~
                ON 'Return':U OF brw-confirma IN FRAME {&frame01Name} DO:   ~
                    APPLY 'Go':U TO THIS-PROCEDURE.   ~
                END.    ~
                ON 'ESC':U OF FRAME {&frame01Name} DO:  ~
                    RETURN 'ESC':U. ~
                END.

&GLOBAL-DEFINE ActiveObject1 h-bosc038
&GLOBAL-DEFINE ActiveObject2 h-bosc032
&GLOBAL-DEFINE ActiveObject3 h-bosc070
&GLOBAL-DEFINE ActiveObject4 h-bosc047

{bcp/bc9100.i}
{bcp/bc9101.i}

PROCEDURE InicializaCamposFrame01:

    FIND FIRST ttWork NO-ERROR.

    IF  RETURN-VALUE = 'ESC':U THEN DO:
        ASSIGN vlogfinaliza = YES.
        RETURN RETURN-VALUE.
    END.

    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.

    ASSIGN ttWork.num-documento = 0.

    RUN scbo/bosc038.p PERSISTENT SET h-bosc038.
    RUN scbo/bosc032.p PERSISTENT SET h-bosc032.
    RUN scbo/bosc070.p PERSISTENT SET h-bosc070.
    RUN scbo/bosc137.p PERSISTENT SET h-bosc137.
    RUN scbo/bosc047.p PERSISTENT SET h-bosc047.
    RUN setConstraintEstoque    IN h-bosc038 (INPUT 7,  /* Tranferencia interna */
                                              INPUT 2). /* Sa°da                */
    RUN openQueryStatic         IN h-bosc038 (INPUT 'Estoque':U).
    RUN openQueryStatic         IN h-bosc070 (INPUT 'Main':U).
    RUN openQueryStatic         IN h-bosc047 (INPUT 'Main':U).

    cria_block:
    REPEAT:
        RUN getRecord   IN h-bosc038 (OUTPUT TABLE tt-wm-docto).
        FIND FIRST tt-wm-docto NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-wm-docto THEN DO:
            assign vLogErro = yes
                   vLogSai  = yes.
            {bcp/bc9105.i "301" "Documento n∆o encontrado. (WMS)"}
            return error.
        END.
        RUN goToKey     IN h-bosc070 (INPUT tt-wm-docto.num-docto).
        IF  RETURN-VALUE = 'OK':U THEN DO:
            RUN getIntField in h-bosc070 (INPUT  'idi-sit-docto':U,
                                          OUTPUT i-aux).
            IF  i-aux = 4 THEN DO:
                RUN getNext in h-bosc038.
                IF  RETURN-VALUE = 'NOK':U THEN
                    LEAVE cria_block.
                ELSE
                    NEXT cria_block.
            END.
            run getCharField in h-bosc070 (input 'cod-estab':U,
                                           output c-aux).

            if  c-aux <> ttWork.cod-estabel then do:
                run getNext in h-bosc038.

                if  return-value = 'NOK':U then
                    leave cria_block.
                else 
                    next cria_block.
            end.
            run getCharField in h-bosc070 (input  'cod-depos-entr':U,
                                           output c-aux).

            if  c-aux <> ttWork.cod-depos then do:
                run getNext in h-bosc038.
        
                if  return-value = 'NOK':U then
                    leave cria_block.
                else 
                    next cria_block.
            end.
            run goToKey         in h-bosc047 (input  ttWork.cod-estabel,
                                              input  ttWork.cod-local).
            run getCharField    in h-bosc047 (input  'cod-deposito':U,
                                              output c-aux).
            run getCharField    in h-bosc070 (input  'cod-depos-saida':U,
                                              output c-aux2).

            if  c-aux <> c-aux2 then do:
                run getNext in h-bosc038.
        
                if  return-value = 'NOK':U then
                    leave cria_block.
                else 
                    next cria_block.
            end.
        end.
        run linkToDocto     in h-bosc032 (input h-bosc038).
        run openQueryStatic in h-bosc032 (input 'Docto':U).
        run getBatchRecords in h-bosc032 (input  ?,
                                          input  no,
                                          input  999999,
                                          output i-registros,
                                          output table tt-wm-box-movto).    

        run setConstraintDocto in h-bosc137 (tt-wm-docto.cod-estabel,
                                             tt-wm-docto.cod-local,
                                             tt-wm-docto.id-docto).
        run openQueryStatic in h-bosc137 (input 'Docto':U).                                       
        run getBatchRecords in h-bosc137 (input  ?,
                                          input  no,
                                          input  999999,
                                          output i-registros,
                                          output table ttwm-box-movto-lote).

        /* Agrupando Movimentos Lote para o Movimento */                                      
        for each tt-wm-box-movto 
           where tt-wm-box-movto.cod-lote = '':

           assign i-sequencia-aux = 0
                  l-elimina       = yes.               

           for each ttWm-box-movto-lote 
              where ttWm-box-movto-lote.cod-estabel = tt-wm-box-movto.cod-estabel 
                and ttWm-box-movto-lote.cod-local   = tt-wm-box-movto.cod-local   
                and ttWm-box-movto-lote.id-movto    = tt-wm-box-movto.id-movto:

                assign i-sequencia-aux = i-sequencia-aux + 0.001.

                find first bf-tt-wm-box-movto exclusive
                     where bf-tt-wm-box-movto.cod-estabel   = tt-wm-box-movto.cod-estabel   
                       and bf-tt-wm-box-movto.cod-local     = tt-wm-box-movto.cod-local     
                       and bf-tt-wm-box-movto.id-docto      = tt-wm-box-movto.id-docto      
                       and bf-tt-wm-box-movto.num-seq-item  = tt-wm-box-movto.num-seq-item  
                       and bf-tt-wm-box-movto.cod-lote      = ttWm-box-movto-lote.cod-lote 
                       and bf-tt-wm-box-movto.qtd-item      = ttWm-box-movto-lote.qtd-item 
                       and bf-tt-wm-box-movto.qti-embalagem = 1 no-error.

                if  not avail bf-tt-wm-box-movto then do:
                    create bf-tt-wm-box-movto.
                    assign bf-tt-wm-box-movto.cod-cliente      = ttWm-box-movto-lote.cod-cliente  
                           bf-tt-wm-box-movto.cod-estabel      = ttWm-box-movto-lote.cod-estabel
                           bf-tt-wm-box-movto.cod-embalagem    = ttWm-box-movto-lote.cod-embalagem
                           bf-tt-wm-box-movto.cod-item         = ttWm-box-movto-lote.cod-item  
                           bf-tt-wm-box-movto.cod-local        = ttWm-box-movto-lote.cod-local 
                           bf-tt-wm-box-movto.cod-lote         = ttWm-box-movto-lote.cod-lote    
                           bf-tt-wm-box-movto.cod-picking      = tt-wm-box-movto.cod-picking
                           bf-tt-wm-box-movto.cod-refer        = ttWm-box-movto-lote.cod-refer
                           bf-tt-wm-box-movto.dt-atualizacao   = ttWm-box-movto-lote.dt-transacao 
                           bf-tt-wm-box-movto.dt-transacao     = ttWm-box-movto-lote.dt-transacao
                           bf-tt-wm-box-movto.id-box           = ttWm-box-movto-lote.id-box 
                           bf-tt-wm-box-movto.id-docto         = tt-wm-box-movto.id-docto
                           bf-tt-wm-box-movto.id-movto         = ttWm-box-movto-lote.id-movto + i-sequencia-aux
                           bf-tt-wm-box-movto.ind-status-movto = tt-wm-box-movto.ind-status-movto
                           bf-tt-wm-box-movto.ind-tipo-movto   = tt-wm-box-movto.ind-tipo-movto
                           bf-tt-wm-box-movto.num-seq-item     = tt-wm-box-movto.num-seq-item.
                end.

                if  rowid(bf-tt-wm-box-movto) = rowid(tt-wm-box-movto) then
                    assign l-elimina = no.
                else 
                    assign bf-tt-wm-box-movto.qtd-devol        = bf-tt-wm-box-movto.qtd-devol        + ttWm-box-movto-lote.qtd-devol  
                           bf-tt-wm-box-movto.qtd-item         = bf-tt-wm-box-movto.qtd-item         + ttWm-box-movto-lote.qtd-item 
                           bf-tt-wm-box-movto.qtd-item-orig    = bf-tt-wm-box-movto.qtd-item-orig    + ttWm-box-movto-lote.qtd-item
                           bf-tt-wm-box-movto.qtd-liber-erp    = bf-tt-wm-box-movto.qtd-liber-erp    + ttWm-box-movto-lote.qtd-liber-erp
                           bf-tt-wm-box-movto.qtd-item-packing = bf-tt-wm-box-movto.qtd-item-packing + ttWm-box-movto-lote.qtd-item-packing
                           bf-tt-wm-box-movto.qtd-item-picking = bf-tt-wm-box-movto.qtd-item-picking + ttWm-box-movto-lote.qtd-item
                           bf-tt-wm-box-movto.qti-embalagem    = 1.
            end.

            if  i-sequencia-aux <> 0 and l-elimina then
                delete tt-wm-box-movto.

        end.

        /* Agrupando Movimentos por Lote */

        for each tt-wm-box-movto
           break by tt-wm-box-movto.cod-estabel
                 by tt-wm-box-movto.cod-local
                 by tt-wm-box-movto.id-docto
                 by tt-wm-box-movto.num-seq-item
                 by tt-wm-box-movto.cod-lote
                 by tt-wm-box-movto.id-movto desc:

            if  not first-of(tt-wm-box-movto.cod-lote) then do:
                find last bf-tt-wm-box-movto exclusive
                    where bf-tt-wm-box-movto.cod-estabel  = tt-wm-box-movto.cod-estabel   
                      and bf-tt-wm-box-movto.cod-local    = tt-wm-box-movto.cod-local     
                      and bf-tt-wm-box-movto.id-docto     = tt-wm-box-movto.id-docto      
                      and bf-tt-wm-box-movto.num-seq-item = tt-wm-box-movto.num-seq-item  
                      and bf-tt-wm-box-movto.cod-lote     = tt-wm-box-movto.cod-lote no-error.

                if  avail  bf-tt-wm-box-movto then do:
                    assign bf-tt-wm-box-movto.qtd-devol        = bf-tt-wm-box-movto.qtd-devol        + tt-wm-box-movto.qtd-devol  
                           bf-tt-wm-box-movto.qtd-item         = bf-tt-wm-box-movto.qtd-item         + (tt-wm-box-movto.qtd-item * tt-wm-box-movto.qti-embalagem)
                           bf-tt-wm-box-movto.qtd-item-orig    = bf-tt-wm-box-movto.qtd-item-orig    + tt-wm-box-movto.qtd-item
                           bf-tt-wm-box-movto.qtd-item-packing = bf-tt-wm-box-movto.qtd-item-packing + tt-wm-box-movto.qtd-item-packing
                           bf-tt-wm-box-movto.qtd-item-picking = bf-tt-wm-box-movto.qtd-item-picking + tt-wm-box-movto.qtd-item-picking
                           bf-tt-wm-box-movto.qti-embalagem    = bf-tt-wm-box-movto.qti-embalagem
                           bf-tt-wm-box-movto.qtd-liber-erp    = bf-tt-wm-box-movto.qtd-liber-erp + tt-wm-box-movto.qtd-liber-erp.
                    delete tt-wm-box-movto.
                end.                
            end.
            else
                assign tt-wm-box-movto.qtd-item      = tt-wm-box-movto.qtd-item * tt-wm-box-movto.qti-embalagem
                       tt-wm-box-movto.qti-embalagem = 1.
        end.
        for first tt-wm-box-movto,
            first wm-docto no-lock
            where wm-docto.id-docto = tt-wm-box-movto.id-docto:
            create tt-doctos.
            assign tt-doctos.nr-docto  = int(wm-docto.num-docto)
                   tt-doctos.dat-docto = wm-docto.dt-implan-docto.

        end.
        run getNext in h-bosc038.
        
        if  return-value = 'NOK':U then
            leave cria_block.
    end.

    IF VALID-HANDLE(h-bosc032) THEN RUN destroy IN h-bosc032.
    IF VALID-HANDLE(h-bosc038) THEN RUN destroy IN h-bosc038.
    IF VALID-HANDLE(h-bosc047) THEN RUN destroy IN h-bosc047.
    IF VALID-HANDLE(h-bosc070) THEN RUN destroy IN h-bosc070.
    IF VALID-HANDLE(h-bosc137) THEN RUN destroy IN h-bosc137.

    if  not can-find(first tt-doctos) then do:
        assign vLogErro = yes
               vLogSai  = yes.
        {bcp/bc9105.i "301" "Documento Inv†lido. (WMS)"}
        return error.
    end.
    
    open query qr-doctos for each tt-doctos.
END PROCEDURE.

PROCEDURE GravaCamposFrame01: 

    IF  RETURN-VALUE = 'ESC':U THEN DO:
        RETURN RETURN-VALUE.
    END.

    ASSIGN vLogErro     = NO
           vLogSai      = NO 
           vLogFinaliza = NO.

    IF NOT AVAILABLE ttWork THEN
        FIND FIRST ttWork NO-ERROR.

    IF AVAILABLE tt-doctos THEN
        ASSIGN ttWork.num-documento = tt-doctos.nr-docto
               vLogSai          = YES
               vLogFinaliza     = YES.

    RETURN 'OK':U.
END PROCEDURE.

&ELSE 
    RUN utp/ut-msgs.p (INPUT 'show':U, input 28036, input '').
&ENDIF

