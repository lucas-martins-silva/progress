/* Declaracao de variaveis */
{dibo/bodi037.i tt-doc-fiscal}
{dibo/bodi084.i tt-it-doc-fisc}
{dibo/bodi515.i tt-nota-fisc-adc}

{cdp/cdcfgman.i} 
{cdp/cdcfgdis.i}
{method/dbotterr.i}
 
def var h-bodi037 as handle no-undo.
def var h-bodi084 as handle no-undo.
def var h-bodi515 as handle no-undo.

def new global shared var iId  as integer   no-undo.
def var iCount                as integer   no-undo.
def var cErrorText            as character no-undo.
def var vRowRomaneio          as rowid     no-undo.
def var vFiscalOperationCode1 as character no-undo.
def var vDocumentSeries       as character no-undo.
def var vDocumentNumber       as character no-undo.
def var vFiscalOperationCode2 as character no-undo.
def var iDocumentNumber       as integer   format '9999999' no-undo.

{include/i-epc200.i axrof002}

