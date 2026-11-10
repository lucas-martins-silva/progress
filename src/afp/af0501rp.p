/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0501RP 2.00.00.003 } /*** "010003" ***/
/*****************************************************************************
**       PROGRAMA: AF0501
**       DATA....: Mar‡o de 2004    
**       OBJETIVO: Relat½rio de Öndices do Ponto de Controle
**       VERSAO..: 2.00.00.000 - Alan Koerbel
******************************************************************************/
{utp/ut-glob.i}
{utp/utapi019.i}
{afp/af0501.i} 
{afbo/boaf008.i2} /* tt-filtro */
{afbo/boaf008.i3 tt-af-contr-indice-aux}

def temp-table tt-raw-digita
    field raw-digita      as raw.

DEF TEMP-TABLE tt-old-indice LIKE tt-af-contr-indice-aux
  USE-INDEX usuar-alter.

DEF INPUT PARAMETER raw-param AS raw no-undo.
DEF INPUT PARAMETER table FOR tt-raw-digita.

CREATE tt-param.
raw-transfer raw-param TO tt-param.

{include/i-rpvar.i}

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format 'x(132)':U
    index editor-id is primary unique 
          linha.

DEF VAR c-arquivo     AS CHAR FORMAT "x(20)"     NO-UNDO.
DEF VAR c-conteudo    AS CHAR FORMAT "x(100)"    NO-UNDO.
DEF VAR i-cont        AS INTEGER                 NO-UNDO.
DEF VAR i-cont-2      AS INTEGER                 NO-UNDO.
DEF VAR c-texto       AS CHAR FORMAT "x(2000)"   NO-UNDO.
DEF VAR c-texto-email AS CHAR FORMAT "x(2000)"   NO-UNDO.
DEF VAR c-usuario     AS CHAR INITIAL "Usu rio:" NO-UNDO.
DEF VAR i-aux         AS INT NO-UNDO.
DEF VAR c-traco       AS CHARACTER INITIAL "__________" NO-UNDO.
DEF VAR c-des-grp-resp AS CHARACTER     FORMAT "x(40)" NO-UNDO.
DEF VAR c-des-grp-avaliacao AS CHARACTER FORMAT "x(40)" NO-UNDO.


FORM SKIP (2)
    "SELE€ÇO"                 AT  3 SKIP(1)
    tt-param.c-est-ini        COLON 24 "|<  >|" AT 53 tt-param.c-est-fim        NO-LABEL SKIP
    tt-param.i-emi-ini        COLON 24 "|<  >|" AT 53 tt-param.i-emi-fim        NO-LABEL SKIP
    tt-param.c-it-ini         COLON 24 "|<  >|" AT 53 tt-param.c-it-fim         NO-LABEL SKIP
    tt-param.i-nr-ini         COLON 24 "|<  >|" AT 53 tt-param.i-nr-fim         NO-LABEL SKIP
    tt-param.i-ano-ini        COLON 24 LABEL "Per¡odo"
    tt-param.c-des-per-ini    NO-LABEL "|<  >|" AT 53 tt-param.i-ano-fim NO-LABEL
    tt-param.c-des-per-fim    NO-LABEL SKIP
    tt-param.i-cod-gr-forn-ini  COLON 24 "|<  >|" AT 53 tt-param.i-cod-gr-forn-fim NO-LABEL SKIP
    tt-param.c-fm-codigo-ini    COLON 24 "|<  >|" AT 53 tt-param.c-fm-codigo-fim NO-LABEL SKIP
    tt-param.i-ge-codigo-ini    COLON 24 "|<  >|" AT 53 tt-param.i-ge-codigo-fim NO-LABEL SKIP
    tt-param.c-cod-grp-aval-ini COLON 24 "|<  >|" AT 53 tt-param.c-cod-grp-aval-fim NO-LABEL SKIP
    tt-param.c-cod-grp-resp-ini COLON 24 "|<  >|" AT 53 tt-param.c-cod-grp-resp-fim NO-LABEL SKIP
    skip(2)
    "PAR¶METROS"              AT  3  SKIP(1)
    TT-PARAM.c-situacao       COLON 24 SKIP(1)
    "E-mail"                  AT  10 SKIP(1)
    tt-param.l-email          COLON  34
    "Imprime"                 AT 17 SKIP(1)
    tt-param.l-indice-zerado  COLON 44 
    tt-param.l-narrativa      COLON 44 
    tt-param.l-descricao-item colon 44
    tt-param.l-detalha-itens  colon 44
    tt-param.l-pula-linha     colon 44
    skip(2)
    "CLASSIFICA€ÇO"           AT  3  SKIP(1)
    TT-PARAM.desc-classifica[1] COLON 24 label "1a Classificacao"
    TT-PARAM.desc-classifica[2] COLON 24 label "2a Classificacao"
    TT-PARAM.desc-classifica[3] COLON 24 label "3a Classificacao"
    TT-PARAM.desc-classifica[4] COLON 24 label "4a Classificacao"
    TT-PARAM.desc-classifica[5] COLON 24 label "5a Classificacao"
    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).


{include/pi-edit.i} 

FORM tt-editor.conteudo AT 20 FORMAT "x(90)"
     WITH NO-BOX WIDTH 132 CENTERED NO-LABEL DOWN FRAME f-narrativa STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-narrativa:HANDLE).


DEF VAR h-acomp          AS HANDLE     NO-UNDO.
def var c-desc-item      as char       no-undo.
def var h-boaf008        as handle     no-undo.
DEF VAR c-dt-indice      AS CHAR FORMAT "x(10)" NO-UNDO.
DEF VAR c-dt-indice-old  AS CHAR FORMAT "99/99/9999" NO-UNDO.

def temp-table tt-indice
     field c-seq         as char extent 5
     field i-seq         as int extent 5
     field cod-estabel  like af-item-contr-estab-form.cod-estabel
     field cod-emitente like af-item-contr-estab-form.cod-emitente
     field nr-versao    like af-item-contr-estab-form.nr-versao
     field it-codigo    like af-item-contr-estab-form.it-codigo
     field cod-grp-avaliacao LIKE af-item-contr-estab.cod-grp-avaliacao
     field cod-grp-resp LIKE af-item-contr-estab-form.cod-grp-resp
     field nr-controle  like af-item-contr-estab-form.nr-controle 
     field dt-indice    AS DATE FORMAT "99/99/9999" 
     field indice       as   char format "x(10)" label "Öndice"
     field narrativa    like af-item-contr-estab-form.narrativa
     field percentual   like af-item-contr-estab-form.percentual
     FIELD usuar-alter  LIKE af-contr-indice.usuar-alter 
     field desc-item    like item.desc-item
     field nome-abrev   like emitente.nome-abrev
     FIELD log-per-variavel LIKE af-item-contr-estab-form.log-per-variavel.

form tt-indice.cod-estabel  
     tt-indice.cod-emitente
     tt-indice.nome-abrev
     tt-indice.it-codigo
     tt-indice.cod-grp-avaliacao    COLUMN-LABEL "Grp Aval"
     tt-indice.cod-grp-resp         COLUMN-LABEL "Grp Resp"
     tt-indice.nr-controle          COLUMN-LABEL "Nr Contr"
     af-controle.descricao          FORMAT "X(18)" 
     c-dt-indice                    COLUMN-LABEL "Per¡odo"
     tt-indice.percentual
     tt-indice.indice 
     tt-indice.nr-versao            COLUMN-LABEL "Nr Versao"
     with stream-io down width 132 no-box frame f-indice.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-indice:HANDLE).


form tt-indice.cod-estabel  
     tt-indice.cod-emitente
     tt-indice.nome-abrev
     tt-indice.it-codigo
     tt-indice.cod-grp-avaliacao COLUMN-LABEL "Grp Aval" 
     tt-indice.cod-grp-resp      COLUMN-LABEL "Grp Resp" 
     tt-indice.nr-controle       COLUMN-LABEL "Nr Contr" 
     af-controle.descricao       FORMAT "X(18)"
     c-dt-indice                 COLUMN-LABEL "Per¡odo"
     tt-indice.percentual 
     tt-indice.indice 
     tt-indice.nr-versao         COLUMN-LABEL "Nr Versao"
    with stream-io down width 132 no-box frame f-indice-2.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-indice-2:HANDLE).


{include/i-rpout.i}
{include/i-rpcab.i}

ASSIGN c-programa 	  = "AF0501RP":U
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-sistema      = "AFP":U
       c-titulo-relat = "Relat¢rio de Öndices dos Pontos de Controle".

FIND empresa WHERE empresa.ep-codigo   = i-ep-codigo-usuario NO-LOCK NO-ERROR.
IF AVAIL empresa THEN ASSIGN c-empresa = empresa.razao-social.

FIND param-global NO-LOCK NO-ERROR.
FIND FIRST param_email  NO-LOCK NO-ERROR.

run afbo/boaf008.p persistent set h-boaf008.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Processando ...").
/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Carregando_informa‡äes" *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + " ...").

FOR EACH tt-param EXCLUSIVE-LOCK:
   
    CREATE tt-filtro.
    ASSIGN tt-filtro.ano-ini          = string(tt-param.i-ano-ini)                           
           tt-filtro.ano-fim          = string(tt-param.i-ano-fim)                 
           tt-filtro.periodo-ini      = tt-param.c-des-per-ini          
           tt-filtro.periodo-fim      = tt-param.c-des-per-fim         
           tt-filtro.cod-estabel-ini  = tt-param.c-est-ini         
           tt-filtro.cod-estabel-fim  = tt-param.c-est-fim        
           tt-filtro.cod-emitente-ini = tt-param.i-emi-ini        
           tt-filtro.cod-emitente-fim = tt-param.i-emi-fim      
           tt-filtro.nr-controle-ini  = 0         
           tt-filtro.nr-controle-fim  = 999999      
           tt-filtro.it-codigo-ini    = tt-param.c-it-ini          
           tt-filtro.it-codigo-fim    = tt-param.c-it-fim           
           tt-filtro.cod-grp-aval-ini = tt-param.c-cod-grp-aval-ini       
           tt-filtro.cod-grp-aval-fim = tt-param.c-cod-grp-aval-fim        
           tt-filtro.cod-grp-resp-ini = tt-param.c-cod-grp-resp-ini        
           tt-filtro.cod-grp-resp-fim = tt-param.c-cod-grp-resp-fim        
           tt-filtro.cod-gr-forn-ini  = tt-param.i-cod-gr-forn-ini         
           tt-filtro.cod-gr-forn-fim  = tt-param.i-cod-gr-forn-fim         
           tt-filtro.fm-codigo-ini    = tt-param.c-fm-codigo-ini           
           tt-filtro.fm-codigo-fim    = tt-param.c-fm-codigo-fim           
           tt-filtro.ge-codigo-ini    = tt-param.i-ge-codigo-ini           
           tt-filtro.ge-codigo-fim    = tt-param.i-ge-codigo-fim           
           tt-filtro.indice-nao-digitado       = IF tt-param.i-situacao = 1 THEN YES ELSE NO  
           tt-filtro.indice-digitado-calculado = IF tt-param.i-situacao = 2 THEN YES ELSE NO
           tt-filtro.indice-por-item           = tt-param.l-detalha-itens.
END.

RUN getIndices IN h-boaf008 (INPUT TABLE tt-filtro,
                             OUTPUT TABLE tt-af-contr-indice-aux). 

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Imprimindo" *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + " ...").

FOR EACH tt-af-contr-indice-aux EXCLUSIVE-LOCK:
       FOR FIRST emitente FIELDS (nome-abrev cod-gr-forn)
        WHERE emitente.cod-emitente = tt-af-contr-indice-aux.cod-emitente NO-LOCK. END.

       FOR FIRST ITEM FIELDS(desc-item ge-codigo fm-codigo)
            WHERE ITEM.it-codigo = tt-af-contr-indice-aux.it-codigo NO-LOCK: END.  
       
       CREATE tt-indice.
       ASSIGN tt-indice.cod-estabel       = tt-af-contr-indice-aux.cod-estabel
              tt-indice.cod-emitente      = tt-af-contr-indice-aux.cod-emitente
              tt-indice.nr-versao         = tt-af-contr-indice-aux.nr-versao
              tt-indice.it-codigo         = tt-af-contr-indice-aux.it-codigo 
              tt-indice.cod-grp-avaliacao = tt-af-contr-indice-aux.cod-grp-aval
              tt-indice.cod-grp-resp      = tt-af-contr-indice-aux.cod-grp-resp
              tt-indice.nr-controle       = tt-af-contr-indice-aux.nr-controle
              tt-indice.dt-indice         = tt-af-contr-indice-aux.dt-indice
              tt-indice.percentual        = tt-af-contr-indice-aux.percentual
              tt-indice.narrativa         = tt-af-contr-indice-aux.narrativa 
              tt-indice.nome-abrev        = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
              tt-indice.desc-item         = item.desc-item
              tt-indice.usuar-alter       = tt-af-contr-indice-aux.usuar-alter
              tt-indice.log-per-variavel  = tt-af-contr-indice-aux.log-per-variavel.

        IF tt-af-contr-indice-aux.ind-tipo = 1 THEN 
           ASSIGN tt-indice.indice = string(tt-af-contr-indice-aux.indice,">>>,>>9.99").
        ELSE 
           ASSIGN tt-indice.indice  = "__________".

        CREATE tt-old-indice.
        BUFFER-COPY tt-af-contr-indice-aux to tt-old-indice. 

END.

FIND FIRST tt-param NO-ERROR.

do i-aux = 1 to 5:
   if tt-param.desc-classifica[i-aux] = "---- Nenhuma ----" then next.
   for each tt-indice:
       case tt-param.classifica[i-aux]:
           when 1 then assign tt-indice.c-seq[i-aux] = tt-indice.cod-estabel.
           when 2 then assign tt-indice.i-seq[i-aux] = YEAR(tt-indice.dt-indice) + 
                                                       MONTH(tt-indice.dt-indice).
           when 3 then assign tt-indice.i-seq[i-aux] = tt-indice.cod-emitente.
           when 4 then assign tt-indice.c-seq[i-aux] = tt-indice.it-codigo.
           when 5 then assign tt-indice.i-seq[i-aux] = tt-indice.nr-controle.
       end.
   end.
end.

for each tt-indice
     by tt-indice.c-seq[1]
     by tt-indice.i-seq[1]
     by tt-indice.c-seq[2]
     by tt-indice.i-seq[2]
     by tt-indice.c-seq[3]
     by tt-indice.i-seq[3]
     by tt-indice.c-seq[4]
     by tt-indice.i-seq[4]
     by tt-indice.c-seq[5]
     by tt-indice.i-seq[5]:

     for first af-controle fields (descricao)
             where af-controle.ep-codigo = i-ep-codigo-usuario 
               and af-controle.nr-controle = tt-indice.nr-controle no-lock. end.

    IF tt-indice.log-per-variavel = NO THEN 
        ASSIGN c-dt-indice = string(month(tt-indice.dt-indice),"99") + "/" + STRING(year(tt-indice.dt-indice),"9999") .
    ELSE 
        ASSIGN c-dt-indice = string(DAY(tt-indice.dt-indice),"99") + "/" + string(month(tt-indice.dt-indice),"99") + "/" + STRING(year(tt-indice.dt-indice),"9999") .

    IF tt-filtro.indice-nao-digitado = YES THEN DO:
            disp tt-indice.cod-estabel  
                 tt-indice.cod-emitente
                 tt-indice.nome-abrev
                 tt-indice.it-codigo
                 tt-indice.cod-grp-avaliacao
                 tt-indice.cod-grp-resp
                 tt-indice.nr-controle
                 af-controle.descricao when avail af-controle 
                 c-dt-indice
                 tt-indice.percentual
                 tt-indice.indice
                 tt-indice.nr-versao
                 with frame f-indice.
                 down with frame f-indice.
    END.
    ELSE DO:
        disp tt-indice.cod-estabel  
             tt-indice.cod-emitente
             tt-indice.nome-abrev
             tt-indice.it-codigo
             tt-indice.cod-grp-avaliacao
             tt-indice.cod-grp-resp
             tt-indice.nr-controle
             af-controle.descricao when avail af-controle
             c-dt-indice
             tt-indice.percentual
             tt-indice.indice
             tt-indice.nr-versao
             with frame f-indice-2.
             down with frame f-indice-2.
    END.
    
    if tt-filtro.indice-por-item and
       tt-indice.it-codigo <> "" AND
       tt-param.l-descricao-item  then do:
        PUT SKIP.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Descr._Item" *}
        PUT unformatted space(16) RETURN-VALUE + ": "  trim(tt-indice.desc-item).
    end.
    
    IF NOT tt-filtro.indice-nao-digitado THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER FORMAT "X(10)" NO-UNDO.
        {utp/ut-liter.i "Usu rio" *}
        ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
        PUT c-lbl-liter-usuario + ":" AT 113
             tt-indice.usuar-alter AT 121.
    END.

    if tt-param.l-narrativa then do:
       IF  tt-indice.narrativa <> "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-narrativa-indice AS CHARACTER FORMAT "X(20)" NO-UNDO.
            {utp/ut-liter.i "Narrativa_Öndice" *}
            ASSIGN c-lbl-liter-narrativa-indice = TRIM(RETURN-VALUE).
            PUT FILL('-', 36) AT 20 FORMAT "x(36)" 
                ' ' + c-lbl-liter-narrativa-indice + ' '
                FILL('-', 36) FORMAT "x(36)".
            RUN pi-print-editor (INPUT tt-indice.narrativa, INPUT 90).   
            FOR EACH tt-editor:
                DISP tt-editor.conteudo WITH FRAME f-narrativa.
                DOWN WITH FRAME f-narrativa.
            END.
            PUT SKIP (1).
        END.
    end.
               
    if (tt-param.l-pula-linha and not tt-param.l-descricao-item) or
       (tt-param.l-pula-linha and tt-param.l-descricao-item and tt-indice.it-codigo = "") then put skip (1).

end.

IF tt-param.l-email AND tt-param.i-situacao = 1 THEN DO:
    RUN pi-inicializar in h-acomp (INPUT "Envia e-mail").
    
    FOR EACH tt-af-contr-indice-aux:
        FOR EACH af-grp-resp-usuario 
           WHERE af-grp-resp-usuario.cod-grp-resp = tt-af-contr-indice-aux.cod-grp-resp NO-LOCK:
            CREATE tt-old-indice.
            BUFFER-COPY tt-af-contr-indice-aux TO tt-old-indice
            ASSIGN tt-old-indice.usuar-alter = af-grp-resp-usuario.cod-usuario.
        END.
    END.

    ASSIGN c-texto-email  = "".
    FOR EACH tt-old-indice
       BREAK BY tt-old-indice.usuar-alter:
             RUN pi-acompanhar IN h-acomp (INPUT tt-old-indice.it-codigo).
             if first-of(tt-old-indice.usuar-alter) AND tt-old-indice.usuar-alter <> "" then do:
                 find usuar-mater where
                      usuar-mater.cod-usuario = tt-old-indice.usuar-alter no-lock no-error.
                 
                 assign c-texto-email = "Usu rio: " + TRIM(tt-old-indice.usuar-alter) + " - " + 
                                             trim(usuar-mater.nome-usuar) + CHR(13) + chr(13).
             end.
             IF tt-old-indice.log-per-variavel = NO THEN
                 ASSIGN c-dt-indice = string(month(tt-old-indice.dt-indice),"99") + "/" + STRING(year(tt-old-indice.dt-indice),"9999"). 
             ELSE
                 ASSIGN c-dt-indice = STRING(DAY(tt-old-indice.dt-indice),"99") + "/" + string(month(tt-old-indice.dt-indice),"99") + "/" + STRING(year(tt-old-indice.dt-indice),"9999").

             FOR FIRST af-controle FIELDS (descricao)
                  WHERE af-controle.ep-codigo = i-ep-codigo-usuario 
                    and af-controle.nr-controle = tt-old-indice.nr-controle NO-LOCK. END.

             FOR FIRST estabelec FIELD (nome)
                  WHERE estabelec.cod-estabel = tt-old-indice.cod-estabel NO-LOCK. END.

             FOR FIRST af-grp-avaliacao FIELDS(des-grp-avaliacao)
                   WHERE af-grp-avaliacao.ep-codigo = i-ep-codigo-usuario 
                     and af-grp-avaliacao.cod-grp-avaliacao = tt-old-indice.cod-grp-aval NO-LOCK: END.  
             IF AVAIL af-grp-avaliacao THEN
                 ASSIGN c-des-grp-avaliacao = af-grp-avaliacao.des-grp-avaliacao.
             ELSE 
                 ASSIGN c-des-grp-avaliacao = "".

             FOR FIRST af-grp-responsavel FIELDS(des-grp-resp)
                   WHERE af-grp-responsavel.ep-codigo = i-ep-codigo-usuario 
                     and af-grp-responsavel.cod-grp-resp = tt-old-indice.cod-grp-resp NO-LOCK: END.  
             IF AVAIL af-grp-responsavel THEN
                 ASSIGN c-des-grp-resp = af-grp-responsavel.des-grp-resp.
             ELSE
                 ASSIGN c-des-grp-resp = "".
              
             ASSIGN c-texto-email =  c-texto-email 
                                     + "Estab. ......: " + (TRIM(tt-old-indice.cod-estabel)) + " - " + TRIM(estabelec.nome) + CHR(13)  
                                     + "Fornecedor ..: " + STRING(tt-old-indice.cod-emitente) + " - " + trim(tt-old-indice.nome-emit) + CHR(13) 
                                     + "Item ........: " + TRIM(tt-old-indice.it-codigo) + " - " + trim(tt-old-indice.desc-item) + CHR(13)  
                                     + "Grp Avaliacao: " + TRIM(tt-old-indice.cod-grp-aval) + " - " + trim(c-des-grp-avaliacao) + CHR(13)   
                                     + "Grupo Resp...: " + TRIM(tt-old-indice.cod-grp-resp) + " - " + trim(c-des-grp-resp) + CHR(13) 
                                     + "Nr Controle .: " + TRIM(STRING(tt-old-indice.nr-controle)) + " - " + trim(af-controle.descricao) + CHR(13)
                                     + "Per¡odo .....: " + TRIM(STRING(c-dt-indice)) + "            Percentual % : " + TRIM(STRING(tt-old-indice.percentual,">>9.99")) + CHR(13) + CHR(13)
                                     + "Indice: " + c-traco + CHR(13) + CHR(13).

             IF LAST-OF(tt-old-indice.usuar-alter) THEN DO:
                 FOR FIRST af-grp-resp-usuario FIELDS(log-envia-email)
                   WHERE af-grp-resp-usuario.ep-codigo = i-ep-codigo-usuario 
                     and af-grp-resp-usuario.cod-usuario = tt-old-indice.usuar-alter NO-LOCK: END.  
                 IF AVAIL af-grp-resp-usuario AND af-grp-resp-usuario.log-envia-email THEN DO:
                     IF tt-param.i-mensagem > 0 THEN DO:
                       FIND FIRST mensagem WHERE mensagem.cod-mensagem = tt-param.i-mensagem NO-LOCK NO-ERROR.
                       IF AVAIL mensagem THEN 
                           ASSIGN c-texto = mensagem.texto-mensag.
                     END.
                     CREATE tt-mensagem.
                     ASSIGN i-cont = i-cont + 1
                            tt-mensagem.seq-mensagem = i-cont
                            tt-mensagem.mensagem = c-texto + CHR(13) + CHR(13) + CHR(13) +  c-texto-email.
                     RUN pi-enviar-email.
                 END.
                 ASSIGN c-texto-email = "".
                 
             END.
    END.
END.

PAGE.
DISPLAY tt-param.c-est-ini    
        tt-param.c-est-fim 
        tt-param.i-emi-ini 
        tt-param.i-emi-fim
        tt-param.c-it-ini    
        tt-param.c-it-fim 
        tt-param.i-nr-ini   
        tt-param.i-nr-fim 
        tt-param.i-ano-ini
        tt-param.i-ano-fim
        tt-param.c-des-per-ini
        tt-param.c-des-per-fim
        tt-param.c-cod-grp-aval-ini
        tt-param.c-cod-grp-aval-fim
        tt-param.c-cod-grp-resp-ini
        tt-param.c-cod-grp-resp-fim
        tt-param.i-cod-gr-forn-ini 
        tt-param.i-cod-gr-forn-fim
        tt-param.c-fm-codigo-ini
        tt-param.c-fm-codigo-fim
        tt-param.i-ge-codigo-ini 
        tt-param.i-ge-codigo-fim 
        
        tt-param.c-situacao
        tt-param.l-email 
        tt-param.l-indice-zerado
        tt-param.l-narrativa
        tt-param.l-descricao-item
        tt-param.l-detalha-itens
        tt-param.l-pula-linha

        TT-PARAM.desc-classifica[1]
        TT-PARAM.desc-classifica[2]
        TT-PARAM.desc-classifica[3]
        TT-PARAM.desc-classifica[4]
        TT-PARAM.desc-classifica[5]
        WITH  FRAME f-param-sel.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}
       c-arquivo = tt-param.arquivo.

/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-lbl-liter-impressao AS CHARACTER NO-UNDO.
{utp/ut-liter.i "IMPRESSÇO" *}
ASSIGN c-lbl-liter-impressao = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-arquivo AS CHARACTER NO-UNDO.
{utp/ut-liter.i "Arquivo" *}
ASSIGN c-lbl-liter-arquivo = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-usuario-2 AS CHARACTER NO-UNDO.
{utp/ut-liter.i "Usu rio" *}
ASSIGN c-lbl-liter-usuario-2 = TRIM(RETURN-VALUE).
PUT UNFORMATTED SKIP(2)
    c-lbl-liter-impressao  AT 3 skip(1)
    c-lbl-liter-arquivo    AT 17 ": " c-destino " - " c-arquivo
    c-lbl-liter-usuario-2    AT 17 ": ". tt-param.usuario.

{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.


RETURN "OK":U.


PROCEDURE pi-enviar-email:
    FIND usuar-mater WHERE usuar-mater.cod-usuario = tt-old-indice.usuar-alter NO-LOCK NO-ERROR.
    IF AVAIL usuar-mater AND usuar-mater.e-mail <> "" THEN DO:
       FOR EACH tt-envio2:
           DELETE tt-envio2.
       END.   
       FOR EACH tt-erros:
           DELETE tt-erros.
       END.
       
       CREATE tt-envio2.
       ASSIGN tt-envio2.versao-integracao = 1
              tt-envio2.exchange    = param-global.log-1
              tt-envio2.destino     = usuar-mater.e-mail
              tt-envio2.importancia = 2
              tt-envio2.log-enviada = YES
              tt-envio2.log-lida    = YES
              tt-envio2.acomp       = no
              tt-envio2.formato     = "Texto"
              tt-envio2.mensagem    = tt-mensagem.mensagem 
              tt-envio2.remetente   = usuar-mater.e-mail
              tt-envio2.servidor    = param_email.cod_servid_e_mail
              tt-envio2.porta       = param_email.num_porta
              tt-envio2.assunto     = "Notifica‡Æo de pendˆncia de Avalia‡Æo de Fornecedor".
       
       RUN utp/utapi019.p PERSISTENT SET h-utapi019.
       
       RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2,                   
                                      INPUT TABLE tt-mensagem,
                                      OUTPUT TABLE tt-erros).
       DELETE PROCEDURE h-utapi019.
       FIND FIRST tt-erros NO-ERROR.
       IF AVAILABLE tt-erros THEN DO:
          PUT SKIP(1).
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Erros_da_utapi019" *}
          PUT UNFORMATTED RETURN-VALUE + "                 : " AT 0 SKIP.            
          FOR EACH tt-erros:
              PUT UNFORMATTED STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro AT 0 SKIP.                
          END.
       END.
    END.
    FOR EACH tt-mensagem:
        DELETE tt-mensagem.
    END.
   
END. /* if tt-filtro.l-email */
