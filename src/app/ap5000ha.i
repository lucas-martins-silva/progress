/******************************************************************************
***       
*** app/ap5000ha.i - Programa respons vel por Identificar Oportunidades.
***                             
******************************************************************************/

DEF {1} TEMP-TABLE tt-banking NO-UNDO
    FIELD ep-codigo     LIKE mov-ap.ep-codigo
    FIELD razao-social  LIKE empresa.razao-social
    FIELD telefone      LIKE empresa.telefone
    FIELD dt-transacao  LIKE mov-ap.dt-transacao
    FIELD transacao     AS CHAR LABEL "Transa‡Æo"
    FIELD portador      LIKE mov-ap.portador
    FIELD cod-febraban  LIKE portador.cod-febraban
    FIELD usuario       LIKE mov-ap.usuario
    FIELD nome          LIKE usuar_mestre.nom_usuario
    FIELD e-mail        LIKE usuar_mestre.cod_e_mail_local
    FIELD tipo-usuario  LIKE usuar_mestre.ind_tip_usuar
    FIELD qtde-dia      AS INTEGER LABEL "Qtde Dia"
    FIELD da-inicio     AS DATE
    FIELD da-fim        AS DATE
    FIELD MODULO        AS CHAR
    FIELD produto       AS CHAR FORMAT "x(10)" LABEL "Produto"
    INDEX codigo MODULO ep-codigo dt-transacao portador.

/* Fim Include */

