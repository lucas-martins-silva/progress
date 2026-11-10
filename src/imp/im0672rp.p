/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0672RP 2.00.00.001}  /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0672rp MIM}
&ENDIF

{utp/ut-glob.i}

{include/tt-edit.i} /* para impressao da descricao traduzida */
{include/pi-edit.i} /* para impressao da descricao traduzida */

define temp-table tt-param no-undo
    field destino          as integer
    field c-destino        as char                                   
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           as char format "x(35)":U
    field c-cod-docto-ini  as char format "x(16)":U
    field c-cod-docto-fim  as char format "x(16)":U
    field c-cod-idioma-ini as char format "x(12)":U
    field c-cod-idioma-fim as char format "x(12)":U.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.

define stream str-rp.

define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{include/i-rpvar.i}

/***Defini‡Æo de Vari veis***/
DEFINE VARIABLE c-lb-sel      AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE c-lb-cla      AS CHARACTER  NO-UNDO.              
DEFINE VARIABLE c-lb-imp      AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE c-lb-destino  AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE c-lb-usuario  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-execucao AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-idioma   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lb-docto    AS CHARACTER  NO-UNDO. 

DEFINE VARIABLE c-desc AS CHARACTER FORMAT "x(50)":U NO-UNDO.

/*Defini‡Æo de Frames */
FORM trad-docto-import.cod-docto  COLUMN-LABEL "Documento"           FORMAT "x(16)"
     trad-docto-import.cod-idioma COLUMN-LABEL "Idioma"              FORMAT "x(12)"           
     docto-import.des-docto       COLUMN-LABEL "Descri‡Æo"           FORMAT "x(50)"      
     trad-docto-import.des-trad   COLUMN-LABEL "Descri‡Æo Traduzida" FORMAT "x(50)"      
     with down no-box width 132 stream-io frame f-docto.

FORM trad-docto-import.cod-idioma COLUMN-LABEL "Idioma"              FORMAT "x(12)"           
     trad-docto-import.cod-docto  COLUMN-LABEL "Documento"           FORMAT "x(16)"
     docto-import.des-docto       COLUMN-LABEL "Descri‡Æo"           FORMAT "x(50)"      
     trad-docto-import.des-trad   COLUMN-LABEL "Descri‡Æo Traduzida" FORMAT "x(50)"      
     with down no-box width 132 stream-io frame f-idioma.

run utp/ut-trfrrp.p (input frame f-docto:handle).
run utp/ut-trfrrp.p (input frame f-idioma:handle).


/*Tradu‡äes*/
{utp/ut-liter.i SELE€¶O * R}
ASSIGN c-lb-sel = TRIM(RETURN-VALUE).
{utp/ut-liter.i CLASSIFICA€ÇO * R}
ASSIGN c-lb-cla = TRIM(RETURN-VALUE).
{utp/ut-liter.i IMPRESSÇO * R}
ASSIGN c-lb-imp = TRIM(RETURN-VALUE).
{utp/ut-liter.i Destino * r}
ASSIGN c-lb-destino = TRIM(RETURN-VALUE).
{utp/ut-liter.i Execu‡Æo * r}
ASSIGN c-lb-execucao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Usu rio * r}
ASSIGN c-lb-usuario = TRIM(RETURN-VALUE).
{utp/ut-liter.i Idioma  * r}
ASSIGN c-lb-idioma = TRIM(RETURN-VALUE).
{utp/ut-liter.i Documento * r}
ASSIGN c-lb-docto = TRIM(RETURN-VALUE).
RUN utp/ut-liter.p (INPUT tt-param.c-destino,"","").
ASSIGN tt-param.c-destino = TRIM(RETURN-VALUE).
RUN utp/ut-liter.p (INPUT REPLACE(tt-param.desc-classifica," ","_"),"","").
ASSIGN tt-param.desc-classifica = TRIM(RETURN-VALUE).
{utp/ut-liter.i Relat¢rio_Tradu‡äes_Documento}
ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).
                                           
{include/i-rpcab.i}
{include/i-rpout.i}


for first empresa fields (ep-codigo razao-social) where empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK.
    assign c-empresa = empresa.razao-social.
end.

view frame f-cabec.
view frame f-rodape.


/*Bloco Principal*/
IF  tt-param.classifica = 1 THEN DO:
    for each trad-docto-import NO-LOCK
        where (trad-docto-import.cod-docto   >= tt-param.c-cod-docto-ini
          and  trad-docto-import.cod-docto   <= tt-param.c-cod-docto-fim)
          and  (trad-docto-import.cod-idioma >= tt-param.c-cod-idioma-ini
          and   trad-docto-import.cod-idioma <= tt-param.c-cod-idioma-fim)
          break by trad-docto-import.cod-docto:
         
        FIND FIRST docto-import where
                docto-import.cod-docto = trad-docto-import.cod-docto no-lock no-error.
        
        IF trad-docto-import.des-trad <> "":U THEN
            RUN pi-imprime-descricao (INPUT 1).
        ELSE
            ASSIGN c-desc = "":U.

        DISP trad-docto-import.cod-docto  
             trad-docto-import.cod-idioma 
             docto-import.des-docto       
             c-desc @ trad-docto-import.des-trad  
             WITH FRAME f-docto.
             DOWN WITH FRAME f-docto.   

        RUN pi-imprime-descricao (INPUT 2).
    END.
END.
ELSE IF tt-param.classifica = 2 THEN DO: 
    for each trad-docto-import NO-LOCK
        where (trad-docto-import.cod-docto   >= tt-param.c-cod-docto-ini
          and  trad-docto-import.cod-docto   <= tt-param.c-cod-docto-fim)
          and  (trad-docto-import.cod-idioma >= tt-param.c-cod-idioma-ini
          and   trad-docto-import.cod-idioma <= tt-param.c-cod-idioma-fim)
          break by trad-docto-import.cod-idioma
                by trad-docto-import.cod-docto:
         
        FIND FIRST docto-import where
            docto-import.cod-docto = trad-docto-import.cod-docto no-lock no-error.
        
        IF trad-docto-import.des-trad <> "":U THEN
            RUN pi-imprime-descricao (INPUT 1).
        ELSE
            ASSIGN c-desc = "":U.

        DISP trad-docto-import.cod-idioma 
             trad-docto-import.cod-docto  
             docto-import.des-docto       
             c-desc @ trad-docto-import.des-trad  
             WITH FRAME f-idioma.
             DOWN WITH FRAME f-idioma.   
         
        RUN pi-imprime-descricao (INPUT 2).
    END.
END.
            
                
PAGE.

/*P gina de Parƒmetros*/
{utp/ut-liter.i On-line}
put unformatted
    c-lb-sel                skip(1)
    c-lb-docto  at 5  " : "
    tt-param.c-cod-docto-ini  AT 22 "|<  >| " at 45 tt-param.c-cod-docto-fim
    c-lb-idioma at 5  " : "
    tt-param.c-cod-idioma-ini at 22 "|<  >| " at 45 tt-param.c-cod-idioma-fim
    skip(1)
    c-lb-cla                 skip(1)
    tt-param.desc-classifica at 5  skip(1)
    c-lb-imp                 skip(1)
    c-lb-destino             at 5 " : "  tt-param.c-destino " - " tt-param.arquivo
    c-lb-execucao            AT 5 " : " if i-num-ped-exec-rpw = 0 then RETURN-VALUE else "Batch"
    c-lb-usuario             at 5 " : "  tt-param.usuario.


{include/i-rpclo.i}

return "OK":U.
    

PROCEDURE pi-imprime-descricao:
    DEFINE INPUT PARAMETER pLinha AS INTEGER NO-UNDO.
    RUN pi-print-editor(trad-docto-import.des-trad, 50).
    FOR EACH tt-editor: 
        IF pLinha = 1 THEN DO:
            ASSIGN c-desc = tt-editor.conteudo.
            LEAVE.
        END.
        ELSE 
            IF pLinha > 2  THEN DO:
                IF  tt-param.classifica = 1 THEN DO:
                    DISPLAY tt-editor.conteudo @ trad-docto-import.des-trad WITH FRAME f-docto.
                    DOWN WITH FRAME f-docto.
                END.
                ELSE IF  tt-param.classifica = 2 THEN DO:
                    DISPLAY tt-editor.conteudo @ trad-docto-import.des-trad WITH FRAME f-idioma.
                    DOWN WITH FRAME f-idioma.
                END.
            END.

        ASSIGN pLinha = pLinha + 1.                              
    END.
END.

/* FIM */
