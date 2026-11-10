&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0604RP 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0604rp MAB}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: MV0604RP.p
**
**       DATA....: Dezembro de 2003
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: Consulta gERENCIAL DO eQUIPAMENTO
**
*****************************************************************************/
                                             /** Definiá∆o das temp-tables **/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field i-seq            as integer
    field c-cod            as character format "x(300)"
    field i-visao          as integer
    field iTipo            as integer
    field cTipo            as character
    field lParam           as logical.

define shared temp-table tt-digita no-undo
     field sequencia        as integer                     
     field cod-dimensao1    as character format "x(300)"   
     field cod-oficial      as character format "X(20)"    
     field desc-dimensao1   as character format "x(32)"    
     field cod-dimens-pai   as character format "x(300)"   
     field quant-eqpto      as integer                  
     FIELD ano-vida         AS DEC       FORMAT ">>>,>>>,>>9.9"       
     FIELD Km-rodado        AS DEC       FORMAT ">>>,>>>,>>9.9"
     FIELD iIdMedia         AS DEC       FORMAT ">>>,>>>,>>9.9" 
     field r-rowid          as rowid                       
     field p-image          as integer                     
     field seq-tree         as integer                     
     FIELD un               LIKE mab-model.un
     FIELD un-sec           AS CHAR      FORMAT "x(03)"
     FIELD Km-sec           AS DEC       FORMAT ">>>,>>>,>>9.9"
     FIELD hodometro-pri    AS DEC FORMAT ">>>,>>>,>>>,>>9.9" 
     FIELD hodometro-sec    AS DEC FORMAT ">>>,>>>,>>>,>>9.9" 
     index id is primary unique sequencia ascending          
                                cod-dimensao1 ascending.     

def temp-table tt-raw-digita
   field raw-digita as raw.

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.

/****************************************************************************/
                                               /** Definiá∆o de ParÉmetros **/   
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
/****************************************************************************/
                    /** Transferància de parÉmetros para temp-table padr∆o **/
create tt-param.
raw-transfer raw-param to tt-param.
/****************************************************************************/
                                                /** Definiá∆o de Vari†veis **/
DEFINE VARIABLE h-acomp     AS HANDLE                   NO-UNDO.
/**** Descriá‰es ****/
DEFINE VARIABLE cDescStatus AS character format "x(22)"  NO-UNDO.
DEFINE VARIABLE cDescResult AS character format "x(22)"  NO-UNDO.
DEFINE VARIABLE cDescLog    AS CHARACTER format "x(5)"   NO-UNDO.
DEFINE VARIABLE cVal-min    AS CHARACTER  format "x(25)" NO-UNDO.
DEFINE VARIABLE cVal-max    AS CHARACTER  format "x(25)" NO-UNDO.
DEFINE VARIABLE cObs        AS CHARACTER  format "x(12)" NO-UNDO.
DEFINE VARIABLE cDimensao   AS CHARACTER  NO-UNDO.
define buffer bfDigita  for tt-digita.
define buffer bfDigita2 for tt-digita.
define buffer bfDigita3 for tt-digita.
{include/i-rpvar.i}
/****************************************************************************/
                                                     /** Cabeáalho e Forms **/
{abp/ab0604.i1} /*--- Definiá∆o dos frames ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.92
         WIDTH              = 37.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/** Parametriza padr‰es de cabeáalho e rodapÇ a serem exibidos **/
run piInicial in this-procedure.
       
/** Imprime cabeáalho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i}

/** Procedure para inicializar c†lculos e impress∆o **/
run piPrincipal in this-procedure.

/** Fecha o output para arquivo **/
{include/i-rpclo.i}

return "OK":U. 
/*--- Fim do Programa ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayParametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayParametros Procedure 
PROCEDURE displayParametros :
/*------------------------------------------------------------------------------
  Purpose:     displayParametros
  Parameters:  <none>
  Notes:       Mostra os parÉmetros selecionados
------------------------------------------------------------------------------*/
/** Cria a p†gina dos parÉmetros **/
page.

/******************************************************************
  Espaáo reservado para buscar informaá‰es a serem impressas nos 
  parÉmetros (Opcional)
******************************************************************/

/** L¢gica opcional do programador **/

/******************************************************************
  Final do espaáo reservado
******************************************************************/

DISPLAY /*PAR∂METROS*/
        c-liter-par
        tt-param.iTipo
        tt-param.cTipo
        /*IMPRESS«O*/
        c-liter-imp          
        c-destino            
        tt-param.arquivo
        tt-param.usuario     
    WITH FRAME f-param-definidos.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimeDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeDados Procedure 
PROCEDURE imprimeDados :
/*------------------------------------------------------------------------------
  Purpose:     imprimeDados
  Parameters:  <none>
  Notes:       Busca n°veis abaixo, coforme seleá∆o do n°vel
------------------------------------------------------------------------------*/
define input parameter cDimensao as character no-undo.

define variable cPai as character no-undo.

assign cPai = "".

for each  bfDigita 
    where bfDigita.cod-dimens-pai = cDimensao no-lock:
    if cPai <> bfDigita.cod-dimens-pai then do:
            /** Imprime os cabeáalhos **/
            run imprimeVisao (input rowid(bfDigita),         
                              input bfDigita.cod-dimens-pai).
            put skip(2). 
            assign cPai = bfDigita.cod-dimens-pai.
    end.
    {abp/ab0604.i2 bfDigita.p-image}
    assign bfDigita.cod-oficial:label in frame f-dados    = trim(return-value).
    display bfDigita.cod-oficial
            bfDigita.desc-dimensao
            bfDigita.quant-eqpto
            bfDigita.Km-rodado
            bfDigita.un
            bfDigita.Km-sec
            bfDigita.un-sec
            bfDigita.iIdMedia   AT 80
           with frame f-dados.
      down with frame f-dados.
end.
if cPai <> "":U then
put skip(2).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimeDadosComplto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeDadosComplto Procedure 
PROCEDURE imprimeDadosComplto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pDimensao as character no-undo.

define variable cPai as character no-undo.
assign cPai      = "":U
       cDimensao = "":U.


if tt-param.i-visao = 1 then do:
   for first bfDigita3
        where bfDigita3.cod-dimensao = pDimensao no-lock:
           /** Busca label do c¢digo **/
            {abp/ab0604.i2 bfDigita3.p-image}
            assign tt-digita.cod-oficial  :label in frame f-visoes = trim(return-value).
            /** Imprime vis∆o **/
            display bfDigita3.cod-oficial      @ tt-digita.cod-oficial  
                    bfDigita3.desc-dimensao    @ tt-digita.desc-dimensao
                with frame f-visoes.
            down with frame f-visoes.
            put skip(2).
            for each bfDigita
              where bfDigita.cod-dimens-pai = bfDigita3.cod-dimensao no-lock:
               /** Busca vis‰es a serem impressas **/
                    {abp/ab0604.i2 bfDigita.p-image}
                    assign bfDigita.cod-oficial:label in frame f-dados    = trim(return-value).
                    display bfDigita.cod-oficial
                            bfDigita.desc-dimensao
                            bfDigita.quant-eqpto
                            bfDigita.Km-rodado 
                            bfDigita.un    
                            bfDigita.Km-sec
                            bfDigita.un-sec
                            bfDigita.iIdMedia   AT 80
                           with frame f-dados.
                      down with frame f-dados.
            end. 
           put skip(2).
    end.
end.
else do:
    for each bfDigita3
        where bfDigita3.cod-dimens-pai = pDimensao no-lock:
         /** Verifica se existem n°veis abaixo  **/
        if bfDigita3.sequencia <  tt-param.i-visao then do:
            /** Chama recursivamente atÇ encontrar vis∆o pai das tarefas **/
            run imprimeDadosComplto (input bfDigita3.cod-dimensao).
        end.
        else do:
           run imprimeVisaoCompleta (input rowid(bfDigita3),         
                                     input bfDigita3.cod-dimens-pai).
            put skip(2).
            for each bfDigita
              where bfDigita.cod-dimens-pai = cDimensao no-lock:
               /** Busca vis‰es a serem impressas **/
                    {abp/ab0604.i2 bfDigita.p-image}
                    assign bfDigita.cod-oficial:label in frame f-dados    = trim(return-value).
                    display bfDigita.cod-oficial
                            bfDigita.desc-dimensao
                            bfDigita.quant-eqpto
                            bfDigita.Km-rodado  
                            bfDigita.un    
                            bfDigita.Km-sec
                            bfDigita.un-sec
                            bfDigita.iIdMedia   AT 80
                           with frame f-dados.
                      down with frame f-dados.
            end. 
           put skip(2).
        end.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimeVisao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeVisao Procedure 
PROCEDURE imprimeVisao :
/*------------------------------------------------------------------------------
  Purpose:     imprimeVisao
  Parameters:  entrada rRow    = Rowid da temp-table                
               entrada cCodPai = C¢digo da dimens∆o do registro pai 
  Notes:       Imprime os cabeáalhos, buscando os n°veis acima do selecionado
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

/** Verifica se existem vis‰es acima **/
if can-find(first bfDigita2
            where bfDigita2.cod-dimensao = cCodPai no-lock) then do:
    /** Se existir, chama recursivamente enquanto existir **/
    for first bfDigita2
        where bfDigita2.cod-dimensao = cCodPai 
      /*  and   bfDigita2.sequencia    > tt-param.i-visao*/  no-lock:
        /** Chamada recursiva **/
        run imprimeVisao (input rowid(bfDigita2),
                          input bfDigita2.cod-dimens-pai).
    end.
end.
if tt-param.i-visao = 1 then do:
    /** Imprime a vis∆o **/
    for first bfDigita2
        where rowid(bfDigita2)      = rRow 
        and   bfDigita2.sequencia <=  tt-param.i-visao  no-lock:
        /** Busca label do c¢digo **/
        {abp/ab0604.i2 bfDigita2.p-image}
        assign tt-digita.cod-oficial:label in frame f-visoes = trim(return-value).
        /** Imprime vis∆o **/
        display bfDigita2.cod-oficial   @ tt-digita.cod-oficial   
                bfDigita2.desc-dimensao @ tt-digita.desc-dimensao
            with frame f-visoes.
        down with frame f-visoes.
    end.
end.
else do:
    /** Imprime a vis∆o **/
    for first bfDigita2
        where rowid(bfDigita2)      = rRow 
        and   bfDigita2.sequencia <=  tt-param.i-visao  no-lock:
        /** Busca label do c¢digo **/
        {abp/ab0604.i2 bfDigita2.p-image}
        assign tt-digita.cod-oficial:label in frame f-visoes = trim(return-value).
        /** Imprime vis∆o **/
        display bfDigita2.cod-oficial   @ tt-digita.cod-oficial   
                bfDigita2.desc-dimensao @ tt-digita.desc-dimensao
            with frame f-visoes.
        down with frame f-visoes.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimeVisaoCompleta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeVisaoCompleta Procedure 
PROCEDURE imprimeVisaoCompleta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.


/** Verifica se existem vis‰es acima **/
if can-find(first bfDigita2
            where bfDigita2.cod-dimensao = cCodPai no-lock) then do:
    /** Se existir, chama recursivamente enquanto existir **/
    for first bfDigita2
        where bfDigita2.cod-dimensao = cCodPai no-lock:
        /** Chamada recursiva **/
        run imprimeVisaoCompleta (input rowid(bfDigita2),
                                  input bfDigita2.cod-dimens-pai).
    end.
end.
/** Imprime a vis∆o **/
for first bfDigita2
    where rowid(bfDigita2)      = rRow no-lock:
    /** Busca label do c¢digo **/
    {abp/ab0604.i2 bfDigita2.p-image}
    assign tt-digita.cod-oficial:label in frame f-visoes = trim(return-value).
    /** Imprime vis∆o **/
    display bfDigita2.cod-oficial   @ tt-digita.cod-oficial   
            bfDigita2.desc-dimensao @ tt-digita.desc-dimensao
        with frame f-visoes.
    down with frame f-visoes.
    assign cDimensao = bfDigita2.cod-dimensao.
end.






return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicial Procedure 
PROCEDURE piInicial :
/*------------------------------------------------------------------------------
  Purpose:     piInicial
  Parameters:  <none>
  Notes:       Define os valores que ser∆o mostrados o cabeáalho e rodapÇ
------------------------------------------------------------------------------*/
assign c-programa = "AB/00604"
       c-versao   = "2.00"
       c-revisao  = "000"
       c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}.

find first param-global no-lock no-error.
if  available param-global then
    assign c-empresa = param-global.grupo.

{utp/ut-liter.i "Consulta Gerencial do Equipamento" *}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i ABASTECIMENTO/LUBRIFICAÄ«O *}
assign c-sistema = trim(return-value).


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrincipal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrincipal Procedure 
PROCEDURE piPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     piPrincipal
  Parameters:  <none>
  Notes:       Corpo princiapl da aplicaá∆o
------------------------------------------------------------------------------*/
/** Mostra frames de cabeáalho e rodapÇ padr‰es da Datasul **/
view frame f-cabec.
view frame f-rodape. 

/** Inicializa programa de acompanhamento padr∆o Datasul **/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-titulo-relat).

/*********************************************************************
   Neste espaáo deve-se colocar a l¢gica para busca as informaá‰es e 
   tambÇm para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espaáo.
*********************************************************************/

/** Imprime Somente vis∆o selecionada **/
if tt-param.iTipo = 1 then do:
  /** AtravÇs da vis∆o selecionada, chama a impress∆o **/
  for first tt-digita
      where tt-digita.sequencia    = tt-param.i-seq
      and   tt-digita.cod-dimensao = tt-param.c-cod no-lock:
      /** Busca vis‰es a serem impressas **/
      run imprimeDados (input tt-digita.cod-dimensao).
  end.
end.
/** Imprime Completo **/
else do:
    /** Busca todas as vis‰es de primeiro n°vel **/
    for each  tt-digita
        where tt-digita.sequencia = 1 no-lock:
        /** Busca vis‰es a serem impressas **/
        run imprimeDadosComplto (input tt-digita.cod-dimensao).
                               
    end.
end.

/*********************************************************************
   Fim do espaáo para l¢gica de c†lculo e display das informaá‰es
*********************************************************************/

/** Mostra parÉmetros selecionados **/
if tt-param.lParam then
    run displayParametros in this-procedure.

/** Finaliza programa de acompanhamento padr∆o Datasul **/
run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

