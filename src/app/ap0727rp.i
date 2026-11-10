/*******************************************************************
***
*** app/ap0727rp.i - Defini‡Æo Form's, Variaveis ...
***
*******************************************************************/
/* y2kready */

{include/i-rpvar.i}

/*-------- Estas varivaveis serÆo atualizadas conforme tt-param --------*/
def var i-for-ini      like emitente.cod-emit                     no-undo.
def var i-for-fim      like emitente.cod-emit init 99999          no-undo.
def var i-gru-ini      like emitente.cod-gr-forn                  no-undo.
def var i-gru-fim      like emitente.cod-gr-forn init 99          no-undo.
def var i-empresa      like empresa.ep-codigo                     no-undo.
def var i-ano-base     as integer format "9999"                   no-undo.
def var c-responsavel  as character format "x(32)"                no-undo.
def var c-complemento1 as character format "x(110)"               no-undo.
def var c-telefone     as character format "x(17)"                no-undo. 
def var c-estabel      like estabelec.cod-estabel                 no-undo.
def var da-entrega     as date format "99/99/9999" init today     no-undo.
/*----------------------------------------------------------------------*/

def var de-rend-ano     as decimal format ">>,>>>,>>9.99"         no-undo.
def var de-contr-prev   like de-rend-ano                          no-undo.
def var de-pens-jud     like de-rend-ano                          no-undo.
def var de-irrf-ret     like de-rend-ano                          no-undo.
def var de-outros-5     like de-rend-ano                          no-undo.
def var de-outros-6     like de-rend-ano                          no-undo.
def var de-rend-7       like de-rend-ano                          no-undo.
def var de-irrf-7       like de-rend-ano                          no-undo.

DEF VAR c-ano-base      AS CHAR FORMAT "x(21)"                    NO-UNDO. 

def var c-natureza      as charac format "x(90)"                  no-undo.
def var c-cgc           like empresa.cgc                          no-undo.
def var c-razao-social  like empresa.razao-social format "x(37)"  no-undo.
def var c-endereco      like empresa.endereco format "x(37)"      no-undo.
def var c-cidade        like empresa.cidade format "x(37)"        no-undo.
def var c-outros-5      as character format "x(55)"               no-undo.
def var c-outros-6      as character format "x(55)"               no-undo.
def var i-mes           as integer                                no-undo.
def var i-posicao       as integer                                no-undo.
def var h-acomp         as handle                                 no-undo.

form
    "+----------------------------------------------------------------------+"
    "+----------------------------------------------------------+" at 73
    "| Ministerio da Fazenda                                                |" 
    "|       Comprovante de Rendimentos Pagos e de Retencao     |" at 73
    "| Secretaria da Receita Federal                                        |"
    "|     de Imposto de Renda na Fonte" AT 73
    c-ano-base           at 108 
    " |" AT 131
    "+----------------------------------------------------------------------+"
    "+----------------------------------------------------------+" at 73
    "    1 - FONTE PAGADORA PESSOA JURIDICA OU PESSOA FISICA                 "
    "                                                            " at 73
    "+-----------------------------------------------------------------------"
    "-------------+---------------------------------------------+" at 73
    "| Nome Empresarial/Nome: "                                    at 01
    empresa.razao-social                                           at 26 
    "| CNPJ/CPF"                                                   at 86
    empresa.cgc                                                    at 98
    "|"                                                            at 132 
    "+-----------------------------------------------------------------------"
    "-------------+---------------------------------------------+" at 73
    with no-labels no-attr-space no-box width 132 stream-io frame f-parte-0.

assign empresa.cgc:format in frame f-parte-0 = param-global.formato-id-federal.

form
    "+----------------------------------------------------------------------+"
    "+----------------------------------------------------------+" at 73
    "| Razao Social"                                               at 01
    empresa.nome                                                   at 16
    "||"                                                           at 72
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    with no-labels no-attr-space no-box width 132 stream-io frame f-parte-1-scgc.

form
    "    2 - PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS                      " 
    "+---------------------------+-------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| CPF"                                                        at 01
    emitente.cgc                                                   at 09
    "| Nome completo"                                              at 29
    emitente.nome-emit                                             at &if "{&mgadm_version}" >= "2.06b" &then 49 &else 57 &endif
    "|"                                                            at 132
    "+---------------------------+-------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| Natureza do Rendimento:"                                    at 01
    c-natureza                                                     at 28
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    with no-labels no-attr-space no-box width 136 stream-io frame f-parte-1.

assign emitente.cgc:format in frame f-parte-1 = param-global.formato-id-pessoal.

form
    "    3 - RENDIMENTOS TRIBUTAVEIS, DEDUCOES E IMPOSTO RETIDO NA FONTE     "
    "                                            Valores em Reais" at 73
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 01.Total dos Rendimentos (inclusive ferias)"
    "|"                                                            at 105
    de-rend-ano                                                    at 118
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 02.Contribuicao Previdenciaria Oficial"
    "|"                                                            at 105
    de-contr-prev                                                  at 118
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 03.Contribuicao a Previdencia Privada e ao Fundo de" 
     "Aposentadoria Programada Individual - FAPI"                  at 55
    "|"                                                            at 105
    "0,00"                                                         at 127
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 04.Pensao Alimenticia (Informar Beneficiario no campo 6)"
    "|"                                                            at 105
    de-pens-jud                                                    at 118
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 05.Imposto de Renda Retido"
    "|"                                                            at 105
    de-irrf-ret                                                    at 118
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    with no-labels no-attr-space no-box width 132 stream-io frame f-parte-2.


form                                                                
    "    4 - RENDIMENTOS ISENTOS E NAO TRIBUTAVEIS                           "
    "                                            Valores em Reais" at 73
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 01.Parte Isenta dos Proventos de Aposentadoria, Reserva, Reforma e"
    "Pensao (65 anos ou mais)" at 70
    "|"                                                            at 105
    "0,00"                                                         at 127
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 02.Diarias e Ajudas de Custo                                          " 
    "|"                                                            at 105
    "0,00"                                                         at 127
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 03.Pensao, proventos de aposentadoria ou reforma por molestia grave e"
    "aposentadoria ou reforma por "
    "|"                                                            at 105
    "|"                                                            at 132
    "| acidente em servico"               
    "|"                                                            at 105
    "0,00"                                                         at 127
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 04.Lucro e dividendo apurado a partir de 1996 pago por PJ (Lucro Real,"
    " Presumido ou Arbitrado)"                                     at 73
    "|"                                                            at 105
    "0,00"                                                         at 127
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"

    "-----------------------------------------------------------+" at 73
    "| 05.Valores Pagos ao Titular ou Socio de Microempresa ou Empresa de Peq"
    "ueno Porte, exceto pro labore,"                               at 73
    "|"                                                            at 105
    "|"                                                            at 132
    "| Alugueis ou Servicos Prestados"
    "|"                                                            at 105
    "0,00"                                                         at 127
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73 
    "| 06.Indeniza‡Æo por recisÆo de contrato de trabalho, inclusive a " space (0)
    "t¡tulo de PDV e acidente de trabalho  |"
    "0,00"                                                         at 127
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 07." space(0) c-outros-5
    "|"                                                            at 105
    de-outros-5                                                    at 118
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    with no-labels no-attr-space no-box width 132 stream-io frame f-parte-3.
run utp/ut-trfrrp.p (input frame f-parte-0:handle).
run utp/ut-trfrrp.p (input frame f-parte-1-scgc:handle).
run utp/ut-trfrrp.p (input frame f-parte-2:handle).
run utp/ut-trfrrp.p (input frame f-parte-3:handle).

form                                                                
    "    5 - RENDIMENTOS SUJEITOS A TRIBUTACAO EXCLUSIVA (RENDIMENTO LIQUIDO)"
    "                                            Valores em Reais" at 73
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 01.Decimo Terceiro Salario                                            "
    "|"                                                            at 105
    "0,00"                                                         at 127
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| 02.Outros"
    "|"                                                            at 105
    de-outros-6                                                    at 118
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73

    "    6 - INFORMACOES COMPLEMENTARES                                      "
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "|" c-complemento1                          
        de-complemento1 as char format ">>,>>>,>>9.99" at 118   "|" at 132 skip
    "|" c-complemento2  as char format "x(110)"
        de-complemento2 as char format ">>,>>>,>>9.99" at 118   "|" at 132 skip
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73

    "    7 - RESPONSAVEL PELAS INFORMACOES                                   "
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "| Nome"                                                       at 01
    c-responsavel                                                  at 08
    c-telefone                                                     at 41
    "| Data"                                                       at 59
    da-entrega                                                     at 66
    "| Assinatura"                                                 at 80
    "Dispensado (IN/SRF 120/00)"                                   at 95
    "|"                                                            at 132
    "+-----------------------------------------------------------------------"
    "-----------------------------------------------------------+" at 73
    "Aprovado pelo IN/SRF numero 120/2000"
    with no-labels no-attr-space no-box width 132 stream-io frame f-parte-4.

/* Fim de Include */

