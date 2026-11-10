
/*--- ap0507m.i - Definica‡Æo das temps tt-tit-ap-ava, e tt-erro ---*/

def temp-table tt-tit-ap-ava
    field rowid-tit-ap        as rowid
    field vl-saldo-me-atual   as dec  format "->>>>>>>,>>9.99"
    field vl-saldo-me-anter   as dec  format "->>>>>>>,>>9.99"
    field conta-acerto        as char format "x(17)"
    field portador-acerto     as int  format ">>>>9"
    field modalidade-acerto   as int  format "9"
    field dt-transacao-acerto as date format "99/99/9999"
    field ind-tp-alter        as int. /* 1=Altera‡Æo, 2=Baixa, 
                                         3=Reajuste , 4=Devolu‡Æo */

/*--- tt-erro ---*/
{cdp/cd0666.i}

/*--- Fim ap0507m.i ---*/
