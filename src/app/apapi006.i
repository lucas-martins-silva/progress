/***********************************************************************
Defini‡Æo de vari veis para descri‡Æo de tipo de pagamento
************************************************************************/
def var i-tipo-pag-aux as integer no-undo.

def var c-descricao-pag-bb as char format "x(50)" extent 13 init
    ["01 - Cr‚dito Conta Corrente",
     "02 - Cheque Pagamento",
     "03 - Doc",
     "04 - Ordem Pagto c/ Aviso",
     "05 - Conta em Real Time",
     "10 - Ordem Pagamento",
     "30 - T¡tulo do Banco",
     "31 - T¡tulo Outro Banco",
     "99 - Liquid. Docto F¡sico - COB",
     "41 - TED (CIP/Outra Titularid.)",
     "43 - TED (STR/Mesma Titularid.)",
     "06 - Cr‚d Cta Corren (Mesma Titularidade)",
     "07 - DOC D (Mesma Titularidade)"].

def var c-descricao-pag-bradesco as char format "x(50)" extent 13 init
    ["01 - Cr‚dito Conta Corrente",
     "02 - Cheque Pagamento",
     "03 - Doc",
     "04 - Ordem Pagto c/ Aviso",
     "05 - Conta em Real Time",
     "10 - Ordem Pagamento",
     "30 - T¡tulo do Banco",
     "31 - T¡tulo Outro Banco",
     "99 - Liquid. Docto F¡sico - COB",
     "07 - TED (CIP/Outra Titularid.)",
     "08 - TED (STR/Mesma Titularid.)",
     "06 - Cr‚d Cta Corren (Mesma Titularidade)",
     "07 - DOC D (Mesma Titularidade)"].

def var c-descricao-pag-itau as char format "x(50)" extent 13 init
    ["01 - Cr‚dito Conta Corrente",
     "02 - Cheque Pagamento",
     "03 - Doc",
     "04 - Ordem Pagto c/ Aviso",
     "05 - Conta em Real Time",
     "10 - Ordem Pagamento",
     "30 - T¡tulo do Banco",
     "31 - T¡tulo Outro Banco",
     "99 - Liquid. Docto F¡sico - COB",
     "41 - TED (CIP/Outra Titularid.)",
     "43 - TED (STR/Mesma Titularid.)",
     "06 - Cr‚d Cta Corren (Mesma Titularidade)",
     "07 - DOC D (Mesma Titularidade)"].

def var c-descricao-pag-unibanco as char format "x(50)" extent 13 init
    ["01 - Cr‚dito Conta Corrente",
     "02 - Cheque Pagamento",
     "03 - Doc",
     "04 - Ordem Pagto c/ Aviso",
     "05 - Conta em Real Time",
     "10 - Ordem Pagamento",
     "30 - T¡tulo do Banco",
     "31 - T¡tulo Outro Banco",
     "99 - Liquid. Docto F¡sico - COB",
     "07 - TED (CIP/Outra Titularid.)",
     "08 - TED (STR/Mesma Titularid.)",
     "06 - Cr‚d Cta Corren (Mesma Titularidade)",
     "07 - DOC D (Mesma Titularidade)"].

def var c-descricao-pag-safra-banrisul as char format "x(50)" extent 13 init
    ["01 - Cr‚dito Conta Corrente",
     "02 - Cheque Pagamento",
     "03 - Doc",
     "04 - Ordem Pagto c/ Aviso",
     "05 - Conta em Real Time",
     "10 - Ordem Pagamento",
     "30 - T¡tulo do Banco",
     "31 - T¡tulo Outro Banco",
     "99 - Liquid. Docto F¡sico - COB",
     "83 - TED (CIP/Outra Titularid.)",
     "08 - TED (STR/Mesma Titularid.)",
     "06 - Cr‚d Cta Corren (Mesma Titularidade)",
     "07 - DOC D (Mesma Titularidade)"].

def var c-descricao-pag-boston as char format "x(50)" extent 13 init
    ["01 - Cr‚dito Conta Corrente",
     "02 - Cheque Pagamento",
     "03 - Doc",
     "04 - Ordem Pagto c/ Aviso",
     "05 - Conta em Real Time",
     "10 - Ordem Pagamento",
     "30 - T¡tulo do Banco",
     "31 - T¡tulo Outro Banco",
     "99 - Liquid. Docto F¡sico - COB",
     "83 - TED (CIP/Outra Titularid.)",
     "08 - TED (STR/Mesma Titularid.)",
     "06 - Cr‚d Cta Corren (Mesma Titularidade)",
     "07 - DOC D (Mesma Titularidade)"].

def var c-descricao-pag-real as char format "x(50)" extent 13 init
    ["01 - Cr‚dito Conta Corrente",
     "02 - Cheque Pagamento",
     "03 - Doc",
     "04 - Ordem Pagto c/ Aviso",
     "05 - Conta em Real Time",
     "10 - Ordem Pagamento",
     "30 - T¡tulo do Banco",
     "31 - T¡tulo Outro Banco",
     "99 - Liquid. Docto F¡sico - COB",
     "83 - TED (CIP/Outra Titularid.)",
     "08 - TED (STR/Mesma Titularid.)",
     "06 - Cr‚d Cta Corren (Mesma Titularidade)",
     "07 - DOC D (Mesma Titularidade)"].

def var c-descricao-pag-bcn as char format "x(50)" extent 13 init
    ["01 - Cr‚dito Conta Corrente",
     "02 - Cheque Pagamento",
     "03 - Doc",
     "04 - Ordem Pagto c/ Aviso",
     "05 - Conta em Real Time",
     "10 - Ordem Pagamento",
     "30 - T¡tulo do Banco",
     "31 - T¡tulo Outro Banco",
     "99 - Liquid. Docto F¡sico - COB",
     "83 - TED (CIP/Outra Titularid.)",
     "85 - TED (STR/Mesma Titularid.)",
     "06 - Cr‚d Cta Corren (Mesma Titularidade)",
     "07 - DOC D (Mesma Titularidade)"].

def var c-descricao-pag-outros as char format "x(50)" extent 13 init
    ["01 - Cr‚dito Conta Corrente",
     "02 - Cheque Pagamento",
     "03 - Doc",
     "04 - Ordem Pagto c/ Aviso",
     "05 - Conta em Real Time",
     "10 - Ordem Pagamento",
     "30 - T¡tulo do Banco",
     "31 - T¡tulo Outro Banco",
     "99 - Liquid. Docto F¡sico - COB",
     "83 - TED (CIP/Outra Titularid.)",
     "85 - TED (STR/Mesma Titularid.)",
     "06 - Cr‚d Cta Corren (Mesma Titularidade)",
     "07 - DOC D (Mesma Titularidade)"].

def var c-descricao-pag-varios as char format "x(50)" extent 10 init
    ["01 - Cr‚dito Conta Corrente",
     "02 - Pagamento Cheque",
     "03 - Doc",
     "05 - Cr‚dito em Conta Real Time",
     "07 - TED (CIP/Outra Titularid.)",
     "08 - TED (STR/Mesma Titularid.)",
     "30 - T¡tulo do Banco",
     "31 - T¡tulo Outro Banco",
     "41 - TED (CIP/Outra Titularid.)",
     "43 - TED (STR/Mesma Titularid.)"].
