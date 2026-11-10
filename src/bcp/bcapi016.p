&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
{include/i-prgvrs.i BCAPI016 2.00.00.003} /*** "010003" 05/06/2026 10:44:26  ***/
/*------------------------------------------------------------------------
    File        : BCAPI016.P
    Purpose     : Fornece as procedures que geram os caracteres para 
                  impress∆o do c¢digo de barra.

    Syntax      : run bcp/bcapi016.p persistent set <handle>

    Description : Cada c¢digo de barra possui uma procedure pr¢pria. O nome
                  da procedure Ç generate<barcode> onde barcode pode ser:
                        EAN13
                        Code128A
                        Code128B
                        Code128C
                        EAN128A
                        EAN128B
                        EAN128C
                        Code39
                        I2of5
    
    Author(s)   : Alcides Schulz
    Created     : Novembro/2000
    Notes       : Se ocorrer algum erro na geraá∆o dos caracteres este Ç
                  retornado em return-value.
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
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
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateC128 Procedure 
PROCEDURE generateC128 :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra:
                    Code 128 A, Code 128 B, Code 128 C
                    EAN 128 A, EAN 128 B, EAN 128C
  Parameters:  valor, output caracteres, tipo (A, B ou C), log-ean
  Notes:       Os caracteres gerados devem ser usados com o fonte:
                 "iQs Code 128" - DC-Code128.TTF
  
  Algoritimo do C¢digo de Barra  ===============================================
  Cada elemento no c¢digo 128 ser† representado por 3 barras pretas e 3 barras
  brancas, exceto o Stop Caracter que possui uma barra preta extra.
  O Code128 (tambÇm usado para representar o EAN128) possui 3 tipos:
  A, B e C. Cada um Ç usado para representar os seguintes conjuntos de 
  caracteres:
    Tipo A:  ASCII 00 a 31, 0-9, A-Z, pontuaá∆o (ASCII 00..95)
    Tipo B: 0-9, A-Z, a-z, pontuaá∆o (ASCII 32..127)
    Tipo C: pares numÇricos. Somente representa n£meros codificados de 2 em 2.
  O c¢digo de barra 128 possui os seguintes elementos:
    StartCode - conjunto de barras para representar o c¢digo 128 e identificar
                o tipo A, B ou C
    EAN - quando for usado o EAN128 ser† gerado um conjunto de barras para 
          identificar que Ç EAN128. No caso do Code128 n∆o tem este elemnto.
    Dados - conjunto de barras que representam a informaá∆o
    Digito Verificador - ê gerado com base nos dados representados. ê usado
                         m¢dulo 103.
    StopCode - conjunto de barras que indicam o final do c¢digo.
  O tipo C representa um conjunto de n£meros codificados de 2 em 2 (00 a 99).
  Se o conjunto de n£meros tiver um n£mero impar de elementos ser† adicionado
  um 0 no inicio do valor. Exemplo: 123 ser† representado por 0123.
  
  Geraá∆o dos Caracteres para o Fonte ==========================================
  O fonte usado para o c¢digo 128 fornece os seguintes caracteres que geram
  c¢digo de barra.
    0-9 : ; < = > ? A B C @
  Cada um destes caracteres gera um conjunto de barras. Para representar cada
  elemento de um valor Ç necess†rio combinar estes caracteres conforme a tabela
  vTabCharFont. Assim para o valor ASCII 0, Ç necess†rio gerar os caracteres
  "155", para o valor ASCII 1 ser† gerado "515" e assim por diante.
  O n£mero na tabela vTabCharFont est† na posiá∆o do elemento nas tabelas
  vTabCode128A e vTabCode128B.
  No caso do Tipo C Ç necess†rio pegar de 2 em 2 caracteres e identificar em
  vTabCharFont os caracteres. Por exemplo o valor 50 ser† representado pelo
  elemento 51 da tabela (o campo extent do progress comeáa com 1).
  Para gerar os StartCode Ç usa-se diretamente "A", "B" ou "C". Para o StopCode
  usa-se "@".
  Quando Ç EAN128 deve-se enviar o FNC1.
  Esta rotina calcula o valor do digito verificador.
------------------------------------------------------------------------------*/

def input param pValor      as character no-undo.
def output param pChars     as character no-undo.
def input param pTipo       as character no-undo.
def input param pEAN        as logical   no-undo.

def var vTabCode128A        as character case-sensitive no-undo.
def var vTabCode128B        as character case-sensitive no-undo.
def var vTabCharFont        as character no-undo extent 103
    init [
       "155", "515", "551", "449", "485", "845", "458", "494", "854", "548",  
       "584", "944", "056", "416", "452", "065", "425", "461", "560", "506",  
       "542", "164", "524", "212", "245", "605", "641", "254", "614", "650",  
       "119", "191", "911", "089", "809", "881", "098", "818", "890", "188",  
       "908", "980", "01:", "092", "812", "029", "0:1", "821", "221", "182",  
       "902", "128", "1:0", "122", "209", "281", ":01", "218", "290", ":10",  
       "230", "5<0", ";00", "04=", "0<5", "40=", "4<1", "<05", "<41", "05<",  
       "0=4", "41<", "4=0", "<14", "<50", "=40", "50<", "320", "=04", "830",  
       "047", "407", "443", "074", "434", "470", "344", "704", "740", "113",  
       "131", "311", "00;", "083", "803", "038", "0;0", "308", "380", "023",
       "032", "203", "302"
       ].

vTabCode128A = " !~"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[~\]^_":U.    

vTabCode128B = " !~"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[~\]^_`":U +
               "abcdefghijklmnopqrstuvwxyz~{ ~}~~":U + chr(127).

&scop StartCodeA        "A":U
&scop StartCodeB        "B":U
&scop StartCodeC        "C":U
&scop StopCode          "@":U
&scop FNC1              "302":U

&scop ValueCodeA        103
&scop ValueCodeB        104
&scop ValueCodeC        105
&scop ValueFNC1         102

/* Vari†veis de trabalho ----------------------------------------------------*/
def var vCont       as integer no-undo.
def var vIndex      as integer no-undo.
def var vChar       as character no-undo.
def var vSoma       as integer   no-undo.
def var vPeso       as integer   no-undo.

/* Codigo 128 A (Code ou EAN) ------------------------------------------------*/

if  pTipo = "A":U then do:

    /* Valida caracteres -----------------------------------------------------*/    
    do  vCont = 1 to length(pValor):
        vChar = substr(pValor, vCont, 1).
        if  index(vTabCode128A, vChar) = 0
        and asc(vChar) > 32 then do:
            {utp/ut-liter.i "C128A: Encontrado caracter n∆o permitido:"}
            return trim(return-value) + ' ':U + vChar.
        end.
    end.

    pChars = {&StartCodeA}.
    vSoma = {&ValueCodeA}.
    vPeso = 1.
    if  pEAN then do:
        pChars = pChars + {&FNC1}.
        vSoma = vSoma + {&ValueFNC1}.
        vPeso = vPeso + 1.
    end.
    do  vCont = 1 to length(pValor):
        vChar = substr(pValor, vCont, 1).
        if  asc(vChar) < 32 then
            vIndex = 65 + asc(vChar).
        else
            vIndex = index(vTabCode128A, vChar).

        pChars = pChars + vTabCharFont[vIndex].
        vSoma = vSoma + (vIndex - 1) * vPeso.
        vPeso = vPeso + 1.
    end.
    pChars = pChars + vTabCharFont[(vSoma modulo 103) + 1] + {&StopCode}.
    return "":U.        
end.

/* Codigo 128 B (Code ou EAN) ------------------------------------------------*/

if  pTipo = "B":U then do:

    /* Valida caracteres -----------------------------------------------------*/    
    do  vCont = 1 to length(pValor):
        vChar = substr(pValor, vCont, 1).
        if  index(vTabCode128B, vChar) = 0 then do:
            {utp/ut-liter.i "C128B: Encontrado caracter n∆o permitido:"}
            return trim(return-value) + ' ':U + vChar.
        end.
    end.

    pChars = {&StartCodeB}.
    vSoma = {&ValueCodeB}.
    vPeso = 1.
    if  pEAN then do:
        pChars = pChars + {&FNC1}.
        vSoma = vSoma + {&ValueFNC1}.
        vPeso = vPeso + 1.
    end.
    do  vCont = 1 to length(pValor):
        vChar = substr(pValor, vCont, 1).
        vIndex = index(vTabCode128B, vChar).
        pChars = pChars + vTabCharFont[vIndex].
        vSoma = vSoma + (vIndex - 1) * vPeso.
        vPeso = vPeso + 1.
    end.   
    pChars = pChars + vTabCharFont[(vSoma modulo 103) + 1] + {&StopCode}.
    
    return "":U.
end.

/* Codigo 128 C (Code ou EAN) ------------------------------------------------*/

if  pTipo = "C":U then do:

    /* Valida caracteres -----------------------------------------------------*/    
    do  vCont = 1 to length(pValor):
        vChar = substr(pValor, vCont, 1).
        if  index('01234567890':U, vChar) = 0 then do:
            {utp/ut-liter.i "C128C: Encontrado caracter n∆o numÇrico:"}
            return trim(return-value) + ' ':U + vChar.
        end.
    end.

    if  length(pValor) modulo 2 = 1 then
        pValor = '0' + pValor.
        
    pChars = {&StartCodeC}.
    vSoma = {&ValueCodeC}.
    vPeso = 1.
    if  pEAN then do:
        pChars = pChars + {&FNC1}.
        vSoma = vSoma + {&ValueFNC1}.
        vPeso = vPeso + 1.
    end.
    do  vCont = 1 to length(pValor) by 2:
        vIndex = integer(substr(pValor, vCont, 2)).
        pChars = pChars + vTabCharFont[vIndex + 1].
        vSoma = vSoma + vIndex * vPeso.
        vPeso = vPeso + 1.
    end.
    pChars = pChars + vTabCharFont[(vSoma modulo 103) + 1] + {&StopCode}.
    return "":U.        
end.

/* Retorna erro --------------------------------------------------------------*/
    
    {utp/ut-liter.i "C128: Tipo incorreto, deve ser A, B ou C"}
    return trim(return-value).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateCode128A Procedure 
PROCEDURE generateCode128A :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra Code 128 A
  Parameters:  valor, output caracteres
  Notes:
  
------------------------------------------------------------------------------*/

    def input param pValor     as character no-undo.
    def output param pChars    as character no-undo.

    run generateC128 (pValor, output pChars, "A":U, no).
    return return-value.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateCode128B Procedure 
PROCEDURE generateCode128B :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra Code 128 B
  Parameters:  valor, output caracteres
------------------------------------------------------------------------------*/
    def input param pValor     as character no-undo.
    def output param pChars    as character no-undo.

    run generateC128 (pValor, output pChars, "B":U, no).
    return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateCode128C Procedure 
PROCEDURE generateCode128C :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra Code 128 C
  Parameters:  valor, output caracteres
------------------------------------------------------------------------------*/
    def input param pValor     as character no-undo.
    def output param pChars    as character no-undo.

    run generateC128 (pValor, output pChars, "C":U, no).
    return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateCode39 Procedure 
PROCEDURE generateCode39 :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra Code39
  Parameters:  valor, output caracteres
  Notes:       Os caracteres gerados devem ser usados com o fonte 
                Code 39 - DC-Code39.TTF
  
  Algoritimo do C¢digo de Barra  ===============================================
  
  O c¢digo de barra 39 representa os caracteres definidos em vPermitido. Deve
  ser gerado um "*" no inicio e no final do valor. Este Ç o mais simples de 
  ser usado.
  
  Geraá∆o dos Caracteres para o Fonte ==========================================
  
  Os caracteres s∆o representados diretamente no c¢digo de barra, bastando 
  acrescentar o "*" no inicio e no final. O espaáo em branco Ç substituido
  por "," para ser representado corretamente no fonte.
  
------------------------------------------------------------------------------*/

    def input param pValor     as character no-undo.
    def output param pChars    as character no-undo.

    def var vCont              as integer   no-undo.
    def var vPermitido         as character no-undo case-sensitive
        init ' ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890-+$/.':U.

    /* Valida caracteres permitidos -----------------------------------------*/
    do  vCont = 1 to length(pValor):
        if  index(vPermitido, substr(pValor, vCont, 1)) = 0 then do:
            {utp/ut-liter.i "Code39: Encontrado caracter n∆o permitido:"}
            return trim(return-value) + ' ':U + substr(pValor, vCont, 1).
        end.
    end.

    pChars = '*':U + replace(pValor, ' ':U, ',':U) + '*':U.
    
    return '':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateEAN128A Procedure 
PROCEDURE generateEAN128A :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra EAN 128 A
  Parameters:  valor, output caracteres
------------------------------------------------------------------------------*/
    def input param pValor     as character no-undo.
    def output param pChars    as character no-undo.

    run generateC128 (pValor, output pChars, "A":U, yes).
    return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateEAN128B Procedure 
PROCEDURE generateEAN128B :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra EAN 128 B
  Parameters:  valor, output caracteres
------------------------------------------------------------------------------*/
    def input param pValor     as character no-undo.
    def output param pChars    as character no-undo.

    run generateC128 (pValor, output pChars, "B":U, yes).
    return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateEAN128C Procedure 
PROCEDURE generateEAN128C :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra EAN 128 C
  Parameters:  valor, output caracteres
------------------------------------------------------------------------------*/
    def input param pValor     as character no-undo.
    def output param pChars    as character no-undo.

    run generateC128 (pValor, output pChars, "C":U, yes).
    return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateEAN13 Procedure 
PROCEDURE generateEAN13 :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra EAN13
  Parameters:  valor, output caracteres
  Notes:       Os caracteres gerados devem ser usados com o fonte 
                    EAN-13 - DC-EAN13.TTF
                    EAN-13 Half Height - DC-EAN13HH.TTF
  
  Algoritimo do C¢digo de Barra  ===============================================
  O c¢digo de barra Ç o mais complicado para representar. 
  O EAN13 possui 12 digitos. ê gerado um 13o digito verificador.
  Os dois primeiros digitos representam o pais, 5 digitos contem informaá‰es da
  empresa, 5 digitos contem informaá‰es do produto e o 13 Ç o digito verificador.
  As barras geradas para o c¢digo EAN13 contÇm uma barra inicial  
  (left guard), uma barra especial no centro (center guard) e outra no final 
  (right guard). Os digitos 3 a 7 s∆o representados por valores de duas tabelas
  (tabelas A e B) e que podem variar conforme o pais. Os digitos 8 a 12 s∆o 
  representados por valores da tabela B somente.
  
  Geraá∆o dos Caracteres para o Fonte ==========================================
  Este fonte fornece caracteres ASCII para os elementos necess†rios
  para representar o c¢digo EAN13. Estes valores est∆o representados nas 
  constantes definidas pelo &scop abaixo (ASC_*). 
  Com base no primeiro digito Ç definido quais tabelas ser∆o usadas para
  representar os digitos 3 a 7. O valor do primeiro digito representa
  qual valor devemos usar na tabela vLeftTable.
  Por exemplo o valor 9 vai indicar que deve-se usar as tabelas BBABA (para o 3o
  digito ser† usado a tabela B, para o 4o digito ser† usado a tabela B, para o 
  5o digito ser† usado a tabela A, e assim por diante).
  Para gerar o digito verificador Ç feita a soma dos valores nas posiá‰es
  impares e pares e Ç usado m¢dulo 10 para obter o digito verificador.
  Com base nos valores obtidos Ç gerada uma sequencia de caracteres de acordo
  com as posiá‰es definidas nos preprocessadores ASC_*.
------------------------------------------------------------------------------*/

    def input param pValor     as character no-undo.
    def output param pChars    as character no-undo.

    &scop   ASC_LeftHandA       48
    &scop   ASC_LeftHandB       64
    &scop   ASC_RightHand       80
    &scop   ASC_FirstFlag       33
    &scop   ASC_SecondFlag      96
    &scop   ASC_Check           112
    &scop   ASC_CenterGuard     124
    
    def var vLeftTable      as character extent 10 
        init ['AAAAA',
              'ABABB',
              'ABBAB',
              'ABBBA',
              'BAABB',
              'BBAAB',
              'BBBAA',
              'BABAB',
              'BABBA',
              'BBABA'].

    def var vCont               as integer no-undo.
    
    /* EAN-13 somente trabalha com 12 caracteres numÇricos ------------*/
    if  length(pValor) <> 12 then do:
        {utp/ut-liter.i "EAN13: Tamanho do c¢digo deve ser 12"}
        return trim(return-value).
    end.
    do  vCont = 1 to length(pValor):
        if  index("0123456789":U, substr(pValor, vCont, 1)) = 0 then do:
            {utp/ut-liter.i "EAN13: Encontrado caracter n∆o n£merico:"}
            return trim(return-value) + ' ':U + substr(pValor, vCont, 1).
        end.
    end.

    /* Calcula o digito ----------------------------------------------*/    
    def var vSomaPar        as integer no-undo.
    def var vSomaImpar      as integer no-undo.
    def var vDigito         as integer no-undo.
    
    do  vCont = 12 to 1 by -1:
        if  vCont modulo 2 = 0 then
            vSomaPar = vSomaPar + integer(substr(pValor, vCont, 1)).
        else
            vSomaImpar = vSomaImpar + integer(substr(pValor, vCont, 1)).
    end.
    
    vDigito = 10 - (vSomaPar * 3 + vSomaImpar) modulo 10.
    if  vDigito = 10 then
        vDigito = 0.
    
    /* Gera First e Second Flag --------------------------------------*/

    pChars = chr({&ASC_FirstFlag} + integer(substr(pValor, 1, 1)))
            + chr({&ASC_SecondFlag} + integer(substr(pValor, 2, 1))).

    /* Gera os caracteres para os digitos 3 a 12 ---------------------*/
    def var vValor     as integer no-undo.
    def var vTab37     as integer no-undo.
    
    vTab37 = integer(substr(pValor, 1, 1)) + 1.
    
    do  vCont = 3 to 12:
        vValor = integer(substr(pValor, vCont, 1)).    
        if  vCont < 8 then do: /* digitos de 3 a 7 */
            if  substr(vLeftTable[vTab37], vCont - 2, 1) = 'A':U then
                pChars = pChars + chr({&ASC_LeftHandA} + vValor).
            else 
                pChars = pChars + chr({&ASC_LeftHandB} + vValor).
        end.
        else /* digitos de 8 a 12 */
            pChars = pChars + chr({&ASC_RightHand} + vValor).
        if  vCont = 7 then
            pChars = pChars + chr({&ASC_CenterGuard}).
    end.

    pChars = pChars + chr({&ASC_Check} + vDigito).
    
    return '':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateI2of5 Procedure 
PROCEDURE generateI2of5 :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra Interleaved 2 of 5
  Parameters:  valor, output caracteres
  Notes:       Os caracteres gerados devem ser usados com o fonte :
                c25w - DC-Interleaved2of5.TTF
  
  Algoritimo do C¢digo de Barra  ===============================================
  
  Este c¢digo representa somente n£meros codificados de 2 em 2. O valor a ser
  representado deve conter um n£mero par de digitos. Se for impar acrescenta-se
  um zero no inicio.
  Deve ser gerado um caracter de inicio e um caracter de tÇrmino. O valor pode
  ter qualquer tamanho.
  
  Geraá∆o dos Caracteres para o Fonte ==========================================
  
  Este fonte fornece caracteres ASCII para representar os pares de digitos (00-99)
  conforme tabelas definidas pelos processadores ASC_*. Os caracteres de inicio
  e fim s∆o representados pelos preprocessadores CHR_START e CHR_STOP.
  
------------------------------------------------------------------------------*/

    def input param pValor     as character no-undo.
    def output param pChars    as character no-undo.
    
    /* Localizaá∆o dos caracteres no fonte -----------------------------------*/
    &scop ASC_0031          192
    &scop ASC_3399          33
    &scop ASC_32            159
    &scop CHR_START         chr(123)
    &scop CHR_STOP          chr(125)

    /* Vari†veis de trabalho -------------------------------------------------*/    
    def var vCont       as integer no-undo.
    def var vIndex      as integer no-undo.
    
    /* I2of5 somente aceita caracteres numÇricos -----------------------------*/
    do  vCont = 1 to length(pValor):
        if  index("0123456789":U, substr(pValor, vCont, 1)) = 0 then do:
            {utp/ut-liter.i "I2of5: Encontrado caracter n∆o n£merico:"}
            return trim(return-value) + ' ':U + substr(pValor, vCont, 1).
        end.
    end.
    
    /* Coloca um zero a esquerda se o n£mero de digitos for impar ------------*/
    if  length(pValor) modulo 2 <> 0 then
        pValor = '0' + pValor.
        
    /* calcula o caracter ASCII de acordo com os pares de digitos -----------*/
    pChars = {&CHR_START}.
    do  vCont = 1 to length(pValor) by 2:
        vIndex = integer(substr(pValor, vCont, 2)).
        if  vIndex = 32 then
            pChars = pChars + chr({&ASC_32}).
        else
            if  vIndex < 32 then
                pChars = pChars + chr(vIndex + {&ASC_0031}).
            else
                pChars = pChars + chr(vIndex - 33 + {&ASC_3399}).
    end.
    pChars = pChars + {&CHR_STOP}.

    return "":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateCode128 Procedure 
PROCEDURE generateCode128 :
/*------------------------------------------------------------------------------
  Purpose:     Gera os caracteres para o c¢digo de barra Code 128 H°brido C/A
               para impress∆o de chave de acesso DFe (DACTE, DANFE, DABPE etc.)
               com suporte ao CNPJ AlfanumÇrico.
  Parameters:  valor (chave de acesso), output caracteres
  Notes:       Os caracteres gerados devem ser usados com o fonte:
                 "iQs Code 128" - DC-Code128.TTF
  
  Algoritmo do C¢digo de Barra H°brido C/A =====================================
  Utiliza modelo h°brido combinando CODE 128-C e CODE 128-A:
    - Sempre inicia com Start C (valor 105).
    - Em modo C: codifica pares de d°gitos (00 a 99).
    - Na ocorrància de caracteres n∆o numÇricos, alterna para modo A usando
      o c¢digo de mudanáa CODE A (valor 101 = vTabCharFont[102]).
    - Em modo A: codifica caracteres individuais (d°gitos 0-9, letras A-Z).
    - Quando 4+ d°gitos consecutivos aparecem em modo A (ou 2+ no final),
      alterna de volta para modo C usando CODE C (valor 99 = vTabCharFont[100]).
    - Tratamento de n£mero °mpar de d°gitos:
      - Em modo C: codifica (n-1) como pares, muda para A no £ltimo d°gito.
      - Em modo A: codifica 1ß d°gito em A, depois muda para C.
    - D°gito verificador calculado com m¢dulo 103 (soma ponderada).
    - Stop Code encerra o c¢digo de barras.
  
  Para valores puramente numÇricos (44 d°gitos), o resultado Ç equivalente
  ao generateCode128C.
------------------------------------------------------------------------------*/

    def input param pValor      as character no-undo.
    def output param pChars     as character no-undo.

    def var vTabCode128A        as character case-sensitive no-undo.
    def var vTabCharFont        as character no-undo extent 103
        init [
           "155", "515", "551", "449", "485", "845", "458", "494", "854", "548",  
           "584", "944", "056", "416", "452", "065", "425", "461", "560", "506",  
           "542", "164", "524", "212", "245", "605", "641", "254", "614", "650",  
           "119", "191", "911", "089", "809", "881", "098", "818", "890", "188",  
           "908", "980", "01:", "092", "812", "029", "0:1", "821", "221", "182",  
           "902", "128", "1:0", "122", "209", "281", ":01", "218", "290", ":10",  
           "230", "5<0", ";00", "04=", "0<5", "40=", "4<1", "<05", "<41", "05<",  
           "0=4", "41<", "4=0", "<14", "<50", "=40", "50<", "320", "=04", "830",  
           "047", "407", "443", "074", "434", "470", "344", "704", "740", "113",  
           "131", "311", "00;", "083", "803", "038", "0;0", "308", "380", "023",
           "032", "203", "302"
           ].

    vTabCode128A = " !~"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[~\]^_":U.

    /* Vari†veis de trabalho ------------------------------------------------*/
    def var vCont       as integer   no-undo.
    def var vIndex      as integer   no-undo.
    def var vChar       as character  no-undo.
    def var vSoma       as integer   no-undo.
    def var vPeso       as integer   no-undo.
    def var vMode       as character  no-undo init "C":U.
    def var vDigitCount as integer   no-undo.
    def var vAsc        as integer   no-undo.
    def var vPairValue  as integer   no-undo.
    def var i           as integer   no-undo.

    /* Validaá∆o: apenas d°gitos (0-9) e letras mai£sculas (A-Z) ------------*/
    do  vCont = 1 to length(pValor):
        vChar = substr(pValor, vCont, 1).
        vAsc = asc(vChar).
        if  not ((vAsc >= 48 and vAsc <= 57) or (vAsc >= 65 and vAsc <= 90)) then do:
            {utp/ut-liter.i "C128HybridCA: Encontrado caracter n∆o permitido:"}
            return trim(return-value) + ' ':U + vChar.
        end.
    end.

    /* Inicia com Start C ---------------------------------------------------*/
    pChars = "C":U.
    vSoma  = 105.
    vPeso  = 1.

    /* Loop principal de codificaá∆o ----------------------------------------*/
    vCont = 1.
    do while vCont <= length(pValor):

        if  vMode = "C":U then do:
            /* Conta d°gitos consecutivos a partir da posiá∆o atual */
            vDigitCount = 0.
            do  i = vCont to length(pValor):
                vAsc = asc(substr(pValor, i, 1)).
                if  vAsc >= 48 and vAsc <= 57 then
                    vDigitCount = vDigitCount + 1.
                else
                    leave.
            end.

            if  vDigitCount >= 2 then do:
                if  vDigitCount modulo 2 = 0 then do:
                    /* N£mero par: codifica todos como pares */
                    do  i = 1 to vDigitCount by 2:
                        vPairValue = integer(substr(pValor, vCont, 2)).
                        pChars = pChars + vTabCharFont[vPairValue + 1].
                        vSoma = vSoma + vPairValue * vPeso.
                        vPeso = vPeso + 1.
                        vCont = vCont + 2.
                    end.
                    /* Se h† mais dados, pr¢ximo Ç n∆o-numÇrico: muda para A */
                    if  vCont <= length(pValor) then do:
                        pChars = pChars + vTabCharFont[102]. /* CODE A, valor 101 */
                        vSoma = vSoma + 101 * vPeso.
                        vPeso = vPeso + 1.
                        vMode = "A":U.
                    end.
                end.
                else do:
                    /* N£mero °mpar: codifica (n-1) como pares, £ltimo vai para A */
                    do  i = 1 to (vDigitCount - 1) by 2:
                        vPairValue = integer(substr(pValor, vCont, 2)).
                        pChars = pChars + vTabCharFont[vPairValue + 1].
                        vSoma = vSoma + vPairValue * vPeso.
                        vPeso = vPeso + 1.
                        vCont = vCont + 2.
                    end.
                    /* Muda para A para o d°gito °mpar remanescente */
                    pChars = pChars + vTabCharFont[102]. /* CODE A, valor 101 */
                    vSoma = vSoma + 101 * vPeso.
                    vPeso = vPeso + 1.
                    vMode = "A":U.
                end.
            end.
            else do:
                /* 0 ou 1 d°gito: muda para A */
                pChars = pChars + vTabCharFont[102]. /* CODE A, valor 101 */
                vSoma = vSoma + 101 * vPeso.
                vPeso = vPeso + 1.
                vMode = "A":U.
            end.
        end.

        else do: /* Modo A */
            /* Conta d°gitos consecutivos a partir da posiá∆o atual */
            vDigitCount = 0.
            do  i = vCont to length(pValor):
                vAsc = asc(substr(pValor, i, 1)).
                if  vAsc >= 48 and vAsc <= 57 then
                    vDigitCount = vDigitCount + 1.
                else
                    leave.
            end.

            /* Avalia se deve mudar para C:
               - 4+ d°gitos em qualquer posiá∆o
               - 2+ d°gitos se forem os £ltimos dados (fim da string) */
            if  vDigitCount >= 4
            or  (vDigitCount >= 2 and (vCont + vDigitCount) > length(pValor)) then do:
                if  vDigitCount modulo 2 = 0 then do:
                    /* Par: muda para C antes do primeiro d°gito */
                    pChars = pChars + vTabCharFont[100]. /* CODE C, valor 99 */
                    vSoma = vSoma + 99 * vPeso.
                    vPeso = vPeso + 1.
                    vMode = "C":U.
                end.
                else do:
                    /* ÷mpar: codifica primeiro d°gito em A, depois muda para C */
                    vChar = substr(pValor, vCont, 1).
                    vIndex = index(vTabCode128A, vChar).
                    pChars = pChars + vTabCharFont[vIndex].
                    vSoma = vSoma + (vIndex - 1) * vPeso.
                    vPeso = vPeso + 1.
                    vCont = vCont + 1.
                    /* Muda para C */
                    pChars = pChars + vTabCharFont[100]. /* CODE C, valor 99 */
                    vSoma = vSoma + 99 * vPeso.
                    vPeso = vPeso + 1.
                    vMode = "C":U.
                end.
            end.
            else do:
                /* Codifica caractere individual em modo A */
                vChar = substr(pValor, vCont, 1).
                vAsc = asc(vChar).
                if  vAsc < 32 then
                    vIndex = 65 + vAsc.
                else
                    vIndex = index(vTabCode128A, vChar).
                pChars = pChars + vTabCharFont[vIndex].
                vSoma = vSoma + (vIndex - 1) * vPeso.
                vPeso = vPeso + 1.
                vCont = vCont + 1.
            end.
        end.

    end. /* do while */

    /* D°gito Verificador + Stop Code ---------------------------------------*/
    pChars = pChars + vTabCharFont[(vSoma modulo 103) + 1] + "@":U.

    return "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


