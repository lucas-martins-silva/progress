&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI015 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI015 MUT}
&ENDIF


/*------------------------------------------------------------------------
    File        : BCAPI015.P 
    Purpose     : Gerar Dados para Testar Tipo de Etiqueta

    Syntax      : run bcapi015.p (cod-tipo-etiqueta,
                                  numero-registros, 
                                  tipo-dados,
                                  arquivo-saida,
                                  output tt-etiquetas)

    Description : Gera registros de teste na temp-table de acordo com o 
                  layout do tipo-etiqueta.

    Author(s)   : Alcides Schulz
    Created     : Outubro/2000
    Notes       : retorna 'nok' em caso de erro (usa tt-erro).
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* definiá∆o da temp-table de erros ------------------------------------*/
{cdp/cd0666.i}

/* definiá∆o da temp-table em que ser∆o gerados os registros -----------*/
{bcp/bcapi002.i}

/* parametros do programa ----------------------------------------------*/
def input param p-tipo-etiqueta     as integer no-undo.
def input param p-quant-registros   as integer no-undo.
def input param p-tipo-dados        as integer no-undo. /* 1-Fixo, 2-Sequencial */
def input param p-arquivo-saida     as character no-undo.
def input-output param table for tt-etiqueta.
def input-output param table for tt-erro.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Programa


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD geraCampo Procedure 
FUNCTION geraCampo RETURNS CHARACTER
  ( p-sequencia as integer, p-tipo-campo as integer, p-formato-campo as character, p-inicio as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD geraChar Procedure 
FUNCTION geraChar RETURNS CHARACTER
  ( p-sequencia as integer, p-tamanho as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD geraDate Procedure 
FUNCTION geraDate RETURNS DATE
  ( p-sequencia as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD geraDeci Procedure 
FUNCTION geraDeci RETURNS DECIMAL
  ( p-sequencia as integer, p-tamanho as integer, p-decimais as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD geraInte Procedure 
FUNCTION geraInte RETURNS INTEGER
  ( p-sequencia as integer, p-tamanho as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD geraNatOper Procedure 
FUNCTION geraNatOper RETURNS CHARACTER
  ( p-sequencia as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD geraTime Procedure 
FUNCTION geraTime RETURNS CHARACTER
  ( p-sequencia as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Programa
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

for each tt-etiqueta:
    delete tt-etiqueta.
end.
for each tt-erro.
    delete tt-erro.
end.

/* Le o tipo-etiqueta --------------------------------------------------*/
find tipo-etiqueta no-lock
    where tipo-etiqueta.tipo-etiq = p-tipo-etiqueta
    no-error.
if  not avail tipo-etiqueta then do:
    {utp/ut-table.i mgcld tipo-etiqueta 1}
    run utp/ut-msgs.p ('msg':U, 2, trim(return-value)).
    create tt-erro.
    assign tt-erro.i-sequen = 1
           tt-erro.cd-erro  = 2
           tt-erro.mensagem = return-value.
    {utp/ut-liter.i "Geraá∆o de Teste"}
    tt-erro.mensagem = tt-erro.mensagem + " (":U + return-value + ")":U.
    return 'NOK':U.
end.

/* Cria registros de teste conforme quantidade solicitada -------------*/
run geraRegistros.
return 'OK':U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraRegistros Procedure 
PROCEDURE geraRegistros :
/*------------------------------------------------------------------------------
  Purpose:     Gera os registros de etiqueta (fixo ou simulacao)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var i-num-reg       as integer no-undo.
def var c-formato       as character no-undo.
def var i-tipo          as integer   no-undo.
def var i-inicio        as integer   no-undo.

/* Gera quantidade de registros solicitada -----------------------------------*/
repeat i-num-reg = 1 to p-quant-registros:
    create tt-etiqueta.
    assign tt-etiqueta.i-sequen  = i-num-reg
           tt-etiqueta.tipo-etiq = p-tipo-etiqueta
           tt-etiqueta.arquivo   = p-arquivo-saida
           tt-etiqueta.cod-versao-integracao = 1.
           
    for  each seq-tipo-etiqueta
        where seq-tipo-etiqueta.tipo-etiq = p-tipo-etiqueta no-lock
        by    seq-tipo-etiqueta.sequencia:

        c-formato = seq-tipo-etiqueta.char-1.
        i-tipo    = seq-tipo-etiqueta.int-1.
        i-inicio  = max(1, seq-tipo-etiqueta.int-2).
        
        case int(truncate(seq-tipo-etiqueta.cod-campo / 1000, 0)) :
            when 1 then     /* N£mero da Transaá∆o  */
                 tt-etiqueta.nr-trans = decimal(geraCampo(i-num-reg, i-tipo, c-formato, i-inicio)).
            when 2 then     /* Cod Ènico            */
                 tt-etiqueta.cod-unico = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 3 then     /* C¢digo do Item  1    */
                 tt-etiqueta.it-codigo = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 4 then     /* Data Impress∆o       */
                 tt-etiqueta.dt-impressao = geraDate(i-num-reg).
            when 5 then     /* Dt Validade Lote     */
                 tt-etiqueta.dt-val-lote= geraDate(i-num-reg).
            when 6 then     /* Dep¢sito             */
                 tt-etiqueta.cod-depos = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 7 then     /* Descriá∆o do Item    */
                 tt-etiqueta.desc-item = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 8 then     /* Estabelecimento      */
                 tt-etiqueta.cod-estabel = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 9 then     /* Hora Impress∆o       */
                 tt-etiqueta.hora-impressao = geraTime(i-num-reg).
            when 10 then     /* Localizaá∆o         */
                 tt-etiqueta.cod-localiz = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 11 then     /* Lote/Num SÇrie       */
                 tt-etiqueta.lote = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 12 then     /* Num do Documento     */
                 tt-etiqueta.nr-docto = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 13 then     /* Quantidade           */
                 tt-etiqueta.quantidade = decimal(geraCampo(i-num-reg, i-tipo, c-formato, i-inicio)).
            when 14 then     /* Referància           */
                 tt-etiqueta.cod-referencia = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 15 then     /* T°tulo               */
                 tt-etiqueta.desc-etiqueta = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 16 then     /* Observaá∆o           */
                 tt-etiqueta.observacao = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 20 then     /* Auxiliar 01          */
                 tt-etiqueta.auxiliar-01 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 21 then     /* Auxiliar 02          */
                 tt-etiqueta.auxiliar-02 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 22 then     /* Auxiliar 03          */
                 tt-etiqueta.auxiliar-03 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 23 then     /* Auxiliar 04          */
                 tt-etiqueta.auxiliar-04 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 24 then     /* Auxiliar 05          */
                 tt-etiqueta.auxiliar-05 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 25 then     /* Auxiliar 06          */
                 tt-etiqueta.auxiliar-06 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 26 then     /* Auxiliar 07          */
                 tt-etiqueta.auxiliar-07 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 27 then     /* Auxiliar 08          */
                 tt-etiqueta.auxiliar-08 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 28 then     /* Auxiliar 09          */
                 tt-etiqueta.auxiliar-09 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 29 then     /* Auxiliar 10          */
                 tt-etiqueta.auxiliar-10 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 30 then     /* Serie do Documento  */
                 tt-etiqueta.serie-docto = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 31 then     /* Codigo do Emitente   */
                 tt-etiqueta.cod-emitente = integer(geraCampo(i-num-reg, i-tipo, c-formato, i-inicio)).
            when 32 then     /* Natureza de Operacao */
                 tt-etiqueta.nat-operacao = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 33 then     /* Numero da Transaá∆o Origem */
                 tt-etiqueta.nr-trans-ant = decimal(geraCampo(i-num-reg, i-tipo, c-formato, i-inicio)).
            when 34 then     /* Data do Movimento    */
                 tt-etiqueta.data-movimento = geraDate(i-num-reg).
            when 47 then     /* Item Externo-1   */
                 tt-etiqueta.it-codigo-ext-1 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 48 then     /* Item Externo-2   */
                 tt-etiqueta.it-codigo-ext-2  = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 49 then     /* Item Externo-3   */
                 tt-etiqueta.it-codigo-ext-3 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 50 then     /* Item Externo-4   */
                 tt-etiqueta.it-codigo-ext-4 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 51 then     /* Peso Bruto      */
                 tt-etiqueta.peso-bruto = decimal(geraCampo(i-num-reg, i-tipo, c-formato, i-inicio)).
            when 52 then     /* Peso Liquido     */
                 tt-etiqueta.peso-liquido = decimal(geraCampo(i-num-reg, i-tipo, c-formato, i-inicio)).
            when 53 then     /* Nr.Embalagem */
                 tt-etiqueta.nr-embalagem = decimal(geraCampo(i-num-reg, i-tipo, c-formato, i-inicio)).
            when 55 then     /* Auxiliar 11          */
                 tt-etiqueta.auxiliar-11 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 56 then     /* Auxiliar 12          */
                 tt-etiqueta.auxiliar-12 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 57 then     /* Auxiliar 13          */
                 tt-etiqueta.auxiliar-13 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 58 then     /* Auxiliar 14          */
                 tt-etiqueta.auxiliar-14 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 59 then     /* Auxiliar 15          */
                 tt-etiqueta.auxiliar-15 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 60 then     /* Auxiliar 16          */
                 tt-etiqueta.auxiliar-16 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 61 then     /* Auxiliar 17          */
                 tt-etiqueta.auxiliar-17 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 62 then     /* Auxiliar 18          */
                 tt-etiqueta.auxiliar-18 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 63 then     /* Auxiliar 19          */
                 tt-etiqueta.auxiliar-19 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
            when 64 then     /* Auxiliar 20          */
                 tt-etiqueta.auxiliar-20 = geraCampo(i-num-reg, i-tipo, c-formato, i-inicio).
        end case.
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION geraCampo Procedure 
FUNCTION geraCampo RETURNS CHARACTER
  ( p-sequencia as integer, p-tipo-campo as integer, p-formato-campo as character, p-inicio as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  Gera o valor para os campos auxiliares
    Notes:  
------------------------------------------------------------------------------*/

    def var i-int       as integer no-undo.
    def var i-dec       as integer no-undo.
    def var i-ponto     as integer no-undo.
    
    case p-tipo-campo:
        when 1 then do: /* character */
            return geraChar (p-sequencia, length(string('':U, p-formato-campo)) + p-inicio - 1).
        end.
        when 2 or
        when 3 then do: /* numerico */
            i-ponto = index(p-formato-campo, '.':U).
            if  i-ponto = 0 then do:
                i-int = length(p-formato-campo).
                i-dec = 0.
            end.
            else do:
                i-int = i-ponto - 1.
                i-dec = length(p-formato-campo) - i-ponto.
            end.
            return string(geraDeci(p-sequencia, i-int, i-dec)).
        end.
    end case.

    return ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION geraChar Procedure 
FUNCTION geraChar RETURNS CHARACTER
  ( p-sequencia as integer, p-tamanho as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  Gera conteudo de teste para campo caracter
    Notes:  Quando for sequencia gera uma string com X's + string(p-sequencia, '99999'),
            controlando para que a sequencia apareáa no campo. Trunca a sequencia
            se n∆o couber no formato, por exemplo: ao tentar gerar o valor '16'
            no formato '9', ser† gerado somente '6'.
------------------------------------------------------------------------------*/

    def var i-x     as integer no-undo.
    def var i-9     as integer no-undo.
    
    case p-tipo-dados:
        when 1 then return fill('X', p-tamanho).
        when 2 then do:
            i-x = max(0, p-tamanho - 5).
            i-9 = min(5, p-tamanho).
            if  length(string(p-sequencia)) <= i-9 then
                return fill('X':U, i-x) + string(p-sequencia, fill('9':U, i-9)).
            else
                return fill('X':U, i-x) + substr(string(p-sequencia), length(string(p-sequencia)) - i-9 + 1).
        end.
    end case.
    return ?.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION geraDate Procedure 
FUNCTION geraDate RETURNS DATE
  ( p-sequencia as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  Gera conteudo de teste para campo caracter
    Notes:  
------------------------------------------------------------------------------*/

    case p-tipo-dados:
        when 1 then return today.
        when 2 then return today + p-sequencia.
    end case.
    return ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION geraDeci Procedure 
FUNCTION geraDeci RETURNS DECIMAL
  ( p-sequencia as integer, p-tamanho as integer, p-decimais as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  Gera conteudo de teste para campo decimal
    Notes:  
------------------------------------------------------------------------------*/

    case p-tipo-dados:
        when 1 then return decimal(fill('9', p-tamanho) + ',':U + fill('9', p-decimais)).
        when 2 then return decimal(p-sequencia).
    end case.
    return ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION geraInte Procedure 
FUNCTION geraInte RETURNS INTEGER
  ( p-sequencia as integer, p-tamanho as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  Gera conteudo de teste para campo inteiro
    Notes:  
------------------------------------------------------------------------------*/

    case p-tipo-dados:
        when 1 then return integer(fill('9', p-tamanho)).
        when 2 then return p-sequencia.
    end case.
    return ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION geraNatOper Procedure 
FUNCTION geraNatOper RETURNS CHARACTER
  ( p-sequencia as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  Gera conteudo de teste para campo natureza de operacao
    Notes:  formato da natureza de operacao: 9.99-XXX
------------------------------------------------------------------------------*/

    case p-tipo-dados:
        when 1 then return '999XXX':U.
        when 2 then return string(p-sequencia, '999999':U).
    end case.
    return ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION geraTime Procedure 
FUNCTION geraTime RETURNS CHARACTER
  ( p-sequencia as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  Gera conteudo de teste para campo time
    Notes:  
------------------------------------------------------------------------------*/

    case p-tipo-dados:
        when 1 then return string(time, 'hh:mm:ss':U).
        when 2 then return string(time + p-sequencia, 'hh:mm:ss':U).
    end case.
    return ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


