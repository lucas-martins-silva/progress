{dibo/bodi509.i tt-roman-faturam}
{dibo/bodi510.i tt-item-roman-faturam}
{dibo/bodi511.i tt-item-depos-roman}
{utp/ut-glob.i}
{method/dbotterr.i}

{include/i-epc200.i axrep509}

def var h-bodi509             as handle    no-undo.
def var h-bodi510             as handle    no-undo.
def var h-bodi511             as handle    no-undo.
def var iCount                as integer   no-undo.
def var cErrorText            as character no-undo.
def var vRowRomaneio          as rowid     no-undo.
def var vFiscalOperationCode1 as character no-undo.
def var vDocumentSeries       as character no-undo.
def var vDocumentNumber       as character no-undo.
def var vFiscalOperationCode2 as character no-undo.
def var iDocumentNumber       as decimal format '>>>>>>>>9999999' no-undo.

