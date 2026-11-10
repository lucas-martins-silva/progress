/*
**
** Variaveis para o tratamento dos campos livres da tabela param-imp
** 
*/

&IF DEFINED(bf_mat_versao_ems) &THEN
    
    &IF "{&bf_mat_versao_ems}" < "2.06" &THEN

        ASSIGN i-trib-pis-param-imp            = INTEGER(SUBSTRING({1}.char-1,70,1))
               da-ini-pis-param-imp            = DATE(SUBSTRING({1}.char-1,72,8))
               i-trib-cofins-param-imp         = INTEGER(SUBSTRING({1}.char-1,71,1))
               da-ini-cofins-param-imp         = DATE(SUBSTRING({1}.char-1,80,8))
               l-inc-pis-base-icm-param-imp    = IF INTEGER(SUBSTRING({1}.char-1,88,1)) = 0 THEN NO
                                                 ELSE YES
               l-inc-cofins-base-icm-param-imp = IF INTEGER(SUBSTRING({1}.char-1,89,1)) = 0 THEN NO
                                                 ELSE YES
               c-formula-pis-param-imp         = SUBSTRING({1}.char-2,55,500)
               c-formula-cofins-param-imp      = SUBSTRING({1}.char-2,555,500).

    &ELSE
    
        ASSIGN i-trib-pis-param-imp            = {1}.idi-tributac-pis
               da-ini-pis-param-imp            = {1}.dat-pis-recup
               i-trib-cofins-param-imp         = {1}.idi-tributac-cofins
               da-ini-cofins-param-imp         = {1}.dat-cofins-recup 
               l-inc-pis-base-icm-param-imp    = {1}.log-incid-pis-base-icms
               l-inc-cofins-base-icm-param-imp = {1}.log-incid-cofins-base-icms
               c-formula-pis-param-imp         = {1}.dsl-formul-base-calc-pis
               c-formula-cofins-param-imp      = {1}.dsl-formul-base-calc-cofins.
    
    &ENDIF
    
&ELSE

        ASSIGN i-trib-pis-param-imp            = INTEGER(SUBSTRING({1}.char-1,70,1))
               da-ini-pis-param-imp            = DATE(SUBSTRING({1}.char-1,72,8))
               i-trib-cofins-param-imp         = INTEGER(SUBSTRING({1}.char-1,71,1))
               da-ini-cofins-param-imp         = DATE(SUBSTRING({1}.char-1,80,8))
               l-inc-pis-base-icm-param-imp    = IF INTEGER(SUBSTRING({1}.char-1,88,1)) = 0 THEN NO
                                                 ELSE YES
               l-inc-cofins-base-icm-param-imp = IF INTEGER(SUBSTRING({1}.char-1,89,1)) = 0 THEN NO
                                                 ELSE YES
               c-formula-pis-param-imp         = SUBSTRING({1}.char-2,55,500)
               c-formula-cofins-param-imp      = SUBSTRING({1}.char-2,555,500).
    
&ENDIF



