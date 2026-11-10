def var c-nome-abrev as char no-undo.
def var c-text-1     as char no-undo.
def var c-text-2     as char no-undo.
def var c-text-3     as char no-undo.
def var c-acomp      as char no-undo.
def var log-centr    as log  no-undo.
def var c-conta-var-ant like conta-contab.conta-contabil no-undo.
def var c-ct-var-ant    like conta-contab.ct-codigo no-undo.
def var c-sc-var-ant    like conta-contab.sc-codigo no-undo.
def var c-est-map       as char no-undo.
def var c-ch-map        as char no-undo.
def var da-data-aux     as date no-undo.
def var i-tipo-lancto-d as inte no-undo.
def var i-tipo-lancto-c as inte no-undo.
def var c-lista-trans   as char no-undo. 
def var c-transacao     as char format "x(03)".
DEFINE VARIABLE i-lancamento AS INTEGER    NO-UNDO.
DEF VAR de-vl-iva-retido      LIKE tit-conta-ap.vl-movto.
DEF VAR de-vl-iva-normal      LIKE tit-conta-ap.vl-movto.
DEF VAR de-vl-iva-retido-fasb LIKE tit-conta-ap.vl-movto.
DEF VAR de-vl-iva-normal-fasb LIKE tit-conta-ap.vl-movto.
DEF VAR i-db-cr               AS INT NO-UNDO.

DEF VAR vl-juro-fasb AS DECIMAL NO-UNDO.
DEF VAR vl-mov-fasb AS DECIMAL NO-UNDO.
DEF VAR vl-ant-fasb AS DECIMAL NO-UNDO.
DEF VAR vl-desc-fasb AS DECIMAL NO-UNDO.
DEF VAR vl-multa-fasb AS DECIMAL NO-UNDO.
DEF VAR vl-abatimento-fasb AS DECIMAL NO-UNDO.
DEF VAR vl-fasb AS DECIMAL NO-UNDO.

