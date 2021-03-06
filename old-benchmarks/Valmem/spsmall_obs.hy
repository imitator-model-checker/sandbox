--****************************************************--
--****************************************************--
--   Portion of the SPSMALL memory circuit ("spsmall_blueb_lsv")
--
--   Design by ST-Microelectronics
--   Timings by LIP6
--   Model by LSV
--
--   MODEL WITH OBSERVER (tCKQ conform with ST specification)
--
--   Created       : < 2007
--   Last modified : 2010/04/02
--****************************************************--
--****************************************************--

   var

	s,
	x_net27,
	x_wela,
	x_net13a,
	x_net45,
	x_d_int,
	x_en_latchd,
	x_en_latchwen,
	x_wen_h,
	x_d_h,
	x_observer
		: clock;

	d_up_q_0,
	d_up_net27,
	d_up_d_inta, d_dn_d_inta,
	d_up_wela, d_dn_wela,
	d_up_net45a, d_dn_net45a,
	d_up_net13a, d_dn_net13a,
	d_up_net45, d_dn_net45,
	d_up_d_int, d_dn_d_int,
	d_up_en_latchd, d_dn_en_latchd,
	d_up_en_latchwen, d_dn_en_latchwen,
	d_up_wen_h, d_dn_wen_h,
	d_up_d_h, d_dn_d_h,

	tHI, tLO, tsetupd, tsetupwen
		: parameter;

-- 	second_cycle -- becomes 1 at the beginning of the second clock cycle
-- 		: discrete;


--****************************************************--
--****************************************************--
-- AUTOMATA
--****************************************************--
--****************************************************--


--****************************************************--
  automaton abs_net27	-- ######### ABSTRACTION MANUELLE DE net27 #########
	    		-- ######### et incorporation de retard_q0 #########
			-- ######### ce qui supprime l'autom. ret_q_0 ######
--****************************************************--
synclabs: down_wela, up_wela,
	    down_d_inta, up_d_inta,
		qUp;
initially init_abs_net27;

loc  init_abs_net27 : while True wait {}
	 when True sync up_d_inta goto A_abs_net27;
 	 when True sync down_wela goto C_abs_net27;
 	 when True sync up_wela goto init_abs_net27;
 	 when True sync down_d_inta goto init_abs_net27;

loc  A_abs_net27 : while True wait {}
	 when True sync down_wela do {x_net27'=0} goto B_abs_net27;
	 when True sync up_wela goto A_abs_net27;
 	 when True sync up_d_inta goto A_abs_net27;
	 when True sync down_d_inta goto C_abs_net27;

loc  B_abs_net27 : while x_net27 <= d_up_net27 + d_up_q_0 wait {}
	 when True sync down_wela  goto B_abs_net27;
	 when True sync up_wela goto C_abs_net27;
 	 when True sync up_d_inta goto C_abs_net27;
	 when True sync down_d_inta goto B_abs_net27;
	 when x_net27 = d_up_net27+ d_up_q_0 sync qUp --sync up_net27
	      	      do {} goto C_abs_net27;

loc  C_abs_net27 : while True wait{}
       when True sync down_wela goto C_abs_net27;
       when True sync up_wela goto C_abs_net27;     
       when True sync down_d_inta goto C_abs_net27;     
       when True sync up_d_inta goto C_abs_net27;

end -- not_net27

--****************************************************--
automaton f2_wela		-- wela <= net45a or net13a
--****************************************************--
synclabs: up_net45a, down_net45a,
      up_net13a, down_net13a,
      up_wela, down_wela;


initially e_01_1_wela;

loc  e_00_0_wela : while True wait {}
	 when True sync up_net45a  do {x_wela'=0} goto e_01_X_wela;
	 when True sync up_net13a  do {x_wela'=0} goto e_10_X_wela;
	 when True sync down_net45a  do {} goto e_00_0_wela;
	 when True sync down_net13a  do {} goto e_00_0_wela;
loc  e_01_1_wela : while True wait {}
	 when True sync down_net45a  do {x_wela'=0} goto e_00_X_wela;
	 when True sync up_net13a  do {x_wela'=0} goto e_11_X_wela;
	 when True sync up_net45a  do {} goto e_01_1_wela;
	 when True sync down_net13a  do {} goto e_01_1_wela;
loc  e_10_1_wela : while True wait {}
	 when True sync up_net45a  do {x_wela'=0} goto e_11_X_wela;
	 when True sync down_net13a  do {x_wela'=0} goto e_00_X_wela;
	 when True sync down_net45a  do {} goto e_10_1_wela;
	 when True sync up_net13a  do {} goto e_10_1_wela;
loc  e_11_1_wela : while True wait {}
	 when True sync down_net45a  do {x_wela'=0} goto e_10_X_wela;
	 when True sync down_net13a  do {x_wela'=0} goto e_01_X_wela;
	 when True sync up_net45a  do {} goto e_11_1_wela;
	 when True sync up_net13a  do {} goto e_11_1_wela;
loc  e_00_X_wela: while x_wela <= d_dn_wela wait {}
	 when True sync up_net45a do {x_wela'=0} goto e_01_X_wela;
	 when True sync up_net13a do {x_wela'=0} goto e_10_X_wela;
	 when True sync down_net45a do {} goto e_00_X_wela;
	 when True sync down_net13a do {} goto e_00_X_wela;
	 when x_wela = d_dn_wela sync down_wela do {} goto e_00_0_wela;
loc  e_01_X_wela: while x_wela <= d_up_wela wait {}
	 when True sync down_net45a do {x_wela'=0} goto e_00_X_wela;
	 when True sync up_net13a do {x_wela'=0} goto e_11_X_wela;
	 when True sync up_net45a do {} goto e_01_X_wela;
	 when True sync down_net13a do {} goto e_01_X_wela;
	 when x_wela = d_up_wela sync up_wela 
	      	       do {} goto e_01_1_wela;
loc  e_10_X_wela: while x_wela <= d_up_wela wait {}
	 when True sync up_net45a do {x_wela'=0} goto e_11_X_wela;
	 when True sync down_net13a do {x_wela'=0} goto e_00_X_wela;
	 when True sync down_net45a do {} goto e_10_X_wela;
	 when True sync up_net13a do {} goto e_10_X_wela;
	 when x_wela = d_up_wela sync up_wela 
	      	       do {} goto e_10_1_wela;
loc  e_11_X_wela: while x_wela <= d_up_wela wait {}
	 when True sync down_net45a do {x_wela'=0} goto e_10_X_wela;
	 when True sync down_net13a do {x_wela'=0} goto e_01_X_wela;
	 when True sync up_net45a do {} goto e_11_X_wela;
	 when True sync up_net13a do {} goto e_11_X_wela;
	 when x_wela = d_up_wela sync up_wela 
	      	       do {} goto e_11_1_wela;


	 end -- f2_wela

--****************************************************--
automaton not_net13a
--****************************************************--
synclabs: down_ck, up_ck,
 down_net13a, up_net13a;
initially init_not_net13a;

loc  init_not_net13a : while True wait {}
	 when True sync up_ck do {x_net13a'=0} goto A_not_net13a;
	 when True sync down_ck do {x_net13a'=0} goto B_not_net13a;

loc  A_not_net13a : while x_net13a <= d_dn_net13a wait {}
	 when True sync down_ck do {x_net13a'=0} goto B_not_net13a;
	 when x_net13a = d_dn_net13a sync down_net13a goto init_not_net13a;

loc  B_not_net13a : while x_net13a <= d_up_net13a wait {}
	 when True sync up_ck do {x_net13a'=0} goto A_not_net13a;
	 when x_net13a = d_up_net13a sync up_net13a goto init_not_net13a;

end -- not_net13a


--###########################################################################"
--#### INCORPORATION delai net45a
--#### entraine la suppression de l'automate retard_net45a
--****************************************************--
automaton reg_net45
--****************************************************--
synclabs: down_wen_h, up_wen_h,			-- inputs  (data)
	  down_en_latchwen, up_en_latchwen,	-- inputs (enable)
	  down_net45a, up_net45a ;		-- outputs
initially e0d1_U_reg_net45;

loc e0d0_U_reg_net45: while True wait {}
   		     	when True sync down_en_latchwen do {} goto e0d0_U_reg_net45;
  		     	when True sync down_wen_h do {} goto e0d0_U_reg_net45;
			when True sync up_en_latchwen do {x_net45'=0} goto e1d0_X_reg_net45;
			when True sync up_wen_h do {} goto e0d1_U_reg_net45;

loc e1d0_X_reg_net45: while x_net45 <= d_dn_net45 + d_dn_net45a wait {}
   		     	when True sync down_wen_h do {} goto e1d0_X_reg_net45;
			when True sync up_en_latchwen do {} goto e1d0_X_reg_net45;
			when True sync down_en_latchwen do {} goto e0d0_U_reg_net45;
			when True sync up_wen_h do {x_net45'=0} goto e1d1_X_reg_net45;
			when x_net45 = d_dn_net45 + d_dn_net45a sync down_net45a do {} goto e1d0_0_reg_net45;

loc e1d0_0_reg_net45: while True wait {}
    		     	when True sync down_wen_h do {} goto e1d0_0_reg_net45;
			when True sync down_en_latchwen do {} goto e0d0_U_reg_net45;
			when True sync up_en_latchwen do {} goto e1d0_0_reg_net45;
			when True sync up_wen_h do {x_net45'=0} goto e1d1_X_reg_net45;

loc e0d1_U_reg_net45: while True wait {}
    		     	when True sync up_wen_h do {} goto e0d1_U_reg_net45;
			when True sync down_en_latchwen do {} goto e0d1_U_reg_net45;
			when True sync up_en_latchwen do {x_net45'=0} goto e1d1_X_reg_net45;
			when True sync down_wen_h do {} goto e0d0_U_reg_net45;

loc e1d1_X_reg_net45: while x_net45 <= d_up_net45 + d_up_net45a wait {}
			when True sync down_en_latchwen do {} goto e0d1_U_reg_net45;
			when True sync up_wen_h do {} goto e1d1_X_reg_net45;
			when True sync up_en_latchwen do {} goto e1d1_X_reg_net45;
			when True sync down_wen_h do {x_net45'=0} goto e1d0_X_reg_net45;
			when x_net45 = d_up_net45 + d_up_net45a sync up_net45a goto e1d1_1_reg_net45;

loc e1d1_1_reg_net45: while True wait {}
			when True sync down_en_latchwen do {} goto e0d1_U_reg_net45;
			when True sync up_en_latchwen do {} goto e1d1_1_reg_net45;
			when True sync down_wen_h do {x_net45'=0} goto e1d0_X_reg_net45;
			when True sync up_wen_h do {} goto e1d1_1_reg_net45;
 end -- reg_net45

--###########################################################################"
--#### INCORPORATION delai d_inta
--#### entraine la suppression de l'automate retard_d_inta
--****************************************************--
automaton reg_d_int
--****************************************************--
synclabs: down_d_h, up_d_h,			-- inputs  (data)
	  down_en_latchd, up_en_latchd,		-- inputs (enable)
	  down_d_inta, up_d_inta ;		-- outputs
initially e0d0_U_reg_d_int;

loc e0d0_U_reg_d_int: while True wait {}
    		     	when True sync down_en_latchd do {} goto e0d0_U_reg_d_int;
   		     	when True sync down_d_h do {} goto e0d0_U_reg_d_int;
			when True sync up_en_latchd do {x_d_int'=0} goto e1d0_X_reg_d_int;
			when True sync up_d_h do {} goto e0d1_U_reg_d_int;

loc e1d0_X_reg_d_int: while x_d_int <= d_dn_d_int + d_dn_d_inta wait {}
    		     	when True sync down_d_h do {} goto e1d0_X_reg_d_int;
			when True sync up_en_latchd do {} goto e1d0_X_reg_d_int;
			when True sync down_en_latchd do {} goto e0d0_U_reg_d_int;
			when True sync up_d_h do {x_d_int'=0} goto e1d1_X_reg_d_int;
			when x_d_int = d_dn_d_int + d_dn_d_inta sync down_d_inta goto e1d0_0_reg_d_int;

loc e1d0_0_reg_d_int: while True wait {}
    		     	when True sync down_d_h do {} goto e1d0_0_reg_d_int;
			when True sync down_en_latchd do {} goto e0d0_U_reg_d_int;
			when True sync up_en_latchd do {} goto e1d0_0_reg_d_int;
			when True sync up_d_h do {x_d_int'=0} goto e1d1_X_reg_d_int;

loc e0d1_U_reg_d_int: while True wait {}
    		     	when True sync up_d_h do {} goto e0d1_U_reg_d_int;
			when True sync down_en_latchd do {} goto e0d1_U_reg_d_int;
			when True sync up_en_latchd do {x_d_int'=0} goto e1d1_X_reg_d_int;
			when True sync down_d_h do {} goto e0d0_U_reg_d_int;

loc e1d1_X_reg_d_int: while x_d_int <= d_up_d_int + d_up_d_inta wait {}
			when True sync down_en_latchd do {} goto e0d1_U_reg_d_int;
			when True sync up_d_h do {} goto e1d1_X_reg_d_int;
			when True sync up_en_latchd do {} goto e1d1_X_reg_d_int;
			when True sync down_d_h do {x_d_int'=0} goto e1d0_X_reg_d_int;
			when x_d_int = d_up_d_int + d_up_d_inta sync up_d_inta do {} goto e1d1_1_reg_d_int;

loc e1d1_1_reg_d_int: while True wait {}
			when True sync down_en_latchd do {} goto e0d1_U_reg_d_int;
			when True sync up_en_latchd do {} goto e1d1_1_reg_d_int;
			when True sync down_d_h do {x_d_int'=0} goto e1d0_X_reg_d_int;
			when True sync up_d_h do {} goto e1d1_1_reg_d_int;
 end -- reg_d_int


--****************************************************--
automaton not_en_latchd
--****************************************************--
synclabs: down_ck, up_ck,
 down_en_latchd, up_en_latchd;
initially init_not_en_latchd;

loc  init_not_en_latchd : while True wait {}
	 when True sync up_ck do {x_en_latchd'=0} goto A_not_en_latchd;
	 when True sync down_ck do {x_en_latchd'=0} goto B_not_en_latchd;

loc  A_not_en_latchd : while x_en_latchd <= d_dn_en_latchd wait {}
	 when True sync down_ck do {x_en_latchd'=0} goto B_not_en_latchd;
	 when x_en_latchd = d_dn_en_latchd sync down_en_latchd goto init_not_en_latchd;

loc  B_not_en_latchd : while x_en_latchd <= d_up_en_latchd wait {}
	 when True sync up_ck do {x_en_latchd'=0} goto A_not_en_latchd;
	 when x_en_latchd = d_up_en_latchd sync up_en_latchd goto init_not_en_latchd;

end -- not_en_latchd



--****************************************************--
automaton not_en_latchwen
--****************************************************--
synclabs: down_ck, up_ck,
 down_en_latchwen, up_en_latchwen;
initially init_not_en_latchwen;

loc  init_not_en_latchwen : while True wait {}
	 when True sync up_ck do {x_en_latchwen'=0} goto A_not_en_latchwen;
	 when True sync down_ck do {x_en_latchwen'=0} goto B_not_en_latchwen;

loc  A_not_en_latchwen : while x_en_latchwen <= d_dn_en_latchwen wait {}
	 when True sync down_ck do {x_en_latchwen'=0} goto B_not_en_latchwen;
	 when x_en_latchwen = d_dn_en_latchwen sync down_en_latchwen goto init_not_en_latchwen;

loc  B_not_en_latchwen : while x_en_latchwen <= d_up_en_latchwen wait {}
	 when True sync up_ck do {x_en_latchwen'=0} goto A_not_en_latchwen;
	 when x_en_latchwen = d_up_en_latchwen sync up_en_latchwen goto init_not_en_latchwen;

end -- not_en_latchwen


--****************************************************--
automaton retard_wen_h
--****************************************************--
synclabs: down_wen, up_wen,
 down_wen_h, up_wen_h;
initially init_ret_wen_h;

loc  init_ret_wen_h : while True wait {}
	 when True sync up_wen do {x_wen_h'=0} goto A_ret_wen_h;
	 when True sync down_wen do {x_wen_h'=0} goto B_ret_wen_h;

loc  A_ret_wen_h : while x_wen_h <= d_up_wen_h wait {}
	 when True sync down_wen do {x_wen_h'=0} goto B_ret_wen_h;
	 when x_wen_h = d_up_wen_h sync up_wen_h goto init_ret_wen_h;

loc  B_ret_wen_h : while x_wen_h <= d_dn_wen_h wait {}
	 when True sync up_wen do {x_wen_h'=0} goto A_ret_wen_h;
	 when x_wen_h = d_dn_wen_h sync down_wen_h goto init_ret_wen_h;

end -- not_wen_h



--****************************************************--
automaton retard_d_h
--****************************************************--
synclabs: down_d_0, up_d_0,
 down_d_h, up_d_h;


initially init_ret_d_h;

loc  init_ret_d_h : while True wait {}
	 when True sync up_d_0 do {x_d_h'=0} goto A_ret_d_h;
	 when True sync down_d_0 do {x_d_h'=0} goto B_ret_d_h;

loc  A_ret_d_h : while x_d_h <= d_up_d_h wait {}
	 when True sync down_d_0 do {x_d_h'=0} goto B_ret_d_h;
	 when x_d_h = d_up_d_h sync up_d_h goto init_ret_d_h;

loc  B_ret_d_h : while x_d_h <= d_dn_d_h wait {}
	 when True sync up_d_0 do {x_d_h'=0} goto A_ret_d_h;
	 when x_d_h = d_dn_d_h sync down_d_h goto init_ret_d_h;

end -- not_d_h

--****************************************************--
automaton env
--****************************************************--
synclabs: up_d_0, down_d_0, up_wen, down_wen,
	  down_ck, up_ck;
initially init_env;

loc init_env : while s <= tHI + tLO - tsetupd wait {}
	 when s = tHI + tLO - tsetupd sync up_d_0 goto env1;

loc env1 : while s <= tHI  wait {}
	 when s = tHI  sync down_ck goto env2;

loc env2 : while s <= tHI + tLO - tsetupwen wait {}
	 when s = tHI + tLO - tsetupwen sync down_wen goto env3;

loc env3 : while s <= tHI + tLO wait {}
	 when s = tHI + tLO sync up_ck goto env4;

loc env4 : while s <= 2 tHI + tLO wait {}
	 when s = 2 tHI + tLO sync down_ck goto env5;

loc env5 : while s <= 2 tHI + 2 tLO wait {}
	 when s = 2 tHI + 2 tLO sync up_ck do {} goto env6; -- end_of_cycle' = 1

loc env6 : while True wait{}
--     	 when True goto env6;
end -- env


--****************************************************--
automaton observer
--****************************************************--
synclabs: qUp, CHECKED_______GOOD, CHECKED_______BAD, CHECKED_______TOO_LATE ;
initially waiting;

loc waiting : while True wait {}
-- 	when s < 2 tHI + tLO sync up_d_inta do {} goto waiting;
-- 	when s >= 2 tHI + tLO & s <= tHI + tLO + 109 sync up_d_inta do {x_observer' = 0} goto soon_good;
-- 	when s >= 2 tHI + tLO & s > tHI + tLO + 109 sync up_d_inta do {x_observer' = 0} goto soon_bad;
	when s <= tHI + tLO + 56 sync qUp do {x_observer' = 0} goto soon_good;
	when s  > tHI + tLO + 56 sync qUp do {x_observer' = 0} goto soon_bad;
	when s  = 2tHI + 2tLO sync CHECKED_______TOO_LATE do {x_observer' = 0} goto observer_bad;

loc soon_bad : while x_observer <= 0 wait{}
	when x_observer = 0 sync CHECKED_______BAD goto observer_bad;

loc soon_good : while x_observer <= 0 wait{}
	when x_observer = 0 sync CHECKED_______GOOD goto observer_good;

loc observer_bad : while True wait{}
-- 	when True sync up_d_inta goto observer_bad;

loc observer_good : while True wait{}
-- 	when True sync up_d_inta goto observer_good;

end -- observer



--****************************************************--
--****************************************************--
-- ANALYSIS
--****************************************************--
--****************************************************--

var init, final_reg, bad_reg, post_reg, inter_reg : region;

init := True
 	& loc[abs_net27]       = init_abs_net27 
	& loc[f2_wela]         = e_01_1_wela
	& loc[not_net13a]      = init_not_net13a
	& loc[reg_net45]       = e0d1_U_reg_net45
	& loc[reg_d_int]       = e0d0_U_reg_d_int
	& loc[not_en_latchd]   = init_not_en_latchd 
	& loc[not_en_latchwen] = init_not_en_latchwen
	& loc[retard_wen_h]    = init_ret_wen_h
	& loc[retard_d_h]      = init_ret_d_h

	& loc[env]             = init_env
	& loc[observer]        = waiting


	& s             = 0

	& x_wela        = 0 
	& x_net13a      = 0
	& x_net45       = 0
	& x_d_int       = 0
	& x_en_latchd   = 0
	& x_en_latchwen = 0
	& x_wen_h       = 0
	& x_d_h         = 0
	
-- 	& end_of_cycle  = 0

-- delais pour SP1 (cf. WSEAS06, Fig.5)

	---START PI0---
	& d_up_q_0         = 21
	& d_up_net27       = 0
	& d_up_d_inta      = 22
	& d_dn_d_inta      = 45
	& d_up_wela        = 0
	& d_dn_wela        = 22
	& d_up_net45a      = 5
	& d_dn_net45a      = 4
	& d_up_net13a      = 19
	& d_dn_net13a      = 13
	& d_up_net45       = 21
	& d_dn_net45       = 22
	& d_up_d_int       = 14
	& d_dn_d_int       = 18
	& d_up_en_latchd   = 28
 	& d_dn_en_latchd   = 32
	& d_up_en_latchwen = 5
 	& d_dn_en_latchwen = 4  
	& d_up_wen_h       = 11
	& d_dn_wen_h       = 8
	& d_up_d_h         = 95
  	& d_dn_d_h         = 66

	& tHI              = 45
	& tLO              = 65
-- 	& tsetupd          = 99 -- 108
-- 	& tsetupwen        = 31 -- 48
	---END PI0---
	
	-- CONTRAINTE DE IMITATOR 1
	
--       & 0 <= d_up_wela
--       & 0 <= d_up_en_latchwen
--       & d_up_en_latchd < d_dn_net45 + d_dn_net45a + d_up_en_latchwen
--       & tLO + d_dn_wen_h < tsetupwen + d_up_en_latchd
--       & d_dn_en_latchd < d_dn_net13a + d_dn_wela
--       & tLO <= tsetupd
--       & d_dn_net45 + d_dn_net45a + d_up_en_latchwen < d_up_d_int + d_up_en_latchd + d_up_d_inta
--       & tLO < tsetupwen + d_up_net13a
--       & d_up_d_int + d_up_d_inta + d_up_en_latchd < tLO
--       & d_dn_net13a + d_dn_wela < tHI
--       & d_up_net13a + d_up_wela + tsetupwen < tLO + d_dn_wen_h
--       & tLO + d_up_d_h < d_dn_d_int + d_up_en_latchd + d_dn_d_inta + tsetupd
--       & d_up_d_int + d_up_d_h + d_up_d_inta < tsetupd + d_dn_en_latchd
--       & d_up_net27 + d_dn_net13a + d_up_q_0 + d_dn_wela < tHI + d_up_net13a
--       & tsetupwen + d_up_en_latchwen < tLO
--       & d_up_d_h < tsetupd
--       & tsetupd < tLO + tHI
--       & tsetupd + d_dn_net13a < d_up_d_int + d_up_d_inta + d_up_d_h
--       & tHI + d_up_en_latchwen < d_dn_wela + d_up_net27 + d_dn_net13a + d_up_q_0
--       & tsetupd + d_dn_net45a + d_dn_net45 + d_dn_wen_h + d_up_wela < tsetupwen + d_up_d_h
--       & 0 <= d_dn_en_latchwen
--       & tLO + d_dn_wen_h < d_up_net45 + d_up_net45a + tsetupwen + d_up_en_latchwen
--       & d_dn_en_latchwen < d_dn_net13a


	
;

-- 
-- prints "****************** INITIAL REG ******************";
-- 
-- print init;
-- 
-- prints "****************** POST* ******************";
-- 
-- post_reg := reach forward from init endreach;
-- 
-- print (hide
-- 	s,
-- 	x_net27,
-- 	x_wela,
-- 	x_net13a,
-- 	x_net45,
-- 	x_d_int,
-- 	x_en_latchd,
-- 	x_en_latchwen,
-- 	x_wen_h,
-- 	x_d_h,
-- 	x_observer
-- 	,
-- 	d_up_q_0,
-- 	d_up_net27,
-- 	d_up_d_inta, d_dn_d_inta,
-- 	d_up_wela, d_dn_wela,
-- 	d_up_net45a, d_dn_net45a,
-- 	d_up_net13a, d_dn_net13a,
-- 	d_up_net45, d_dn_net45,
-- 	d_up_d_int, d_dn_d_int,
-- 	d_up_en_latchd, d_dn_en_latchd,
-- 	d_up_en_latchwen, d_dn_en_latchwen,
-- 	d_up_wen_h, d_dn_wen_h,
-- 	d_up_d_h, d_dn_d_h,
-- 
-- 	tHI, tLO
-- 	
--        in post_reg endhide);
-- 	  
-- 
-- 
-- prints "****************** GOOD ******************";
-- 
-- final_reg := post_reg & loc[observer] = observer_good; -- loc[env] = env6;
-- 
-- print (hide
-- 	s,
-- 	x_net27,
-- 	x_wela,
-- 	x_net13a,
-- 	x_net45,
-- 	x_d_int,
-- 	x_en_latchd,
-- 	x_en_latchwen,
-- 	x_wen_h,
-- 	x_d_h,
-- 	x_observer
-- 	,
-- 	d_up_q_0,
-- 	d_up_net27,
-- 	d_up_d_inta, d_dn_d_inta,
-- 	d_up_wela, d_dn_wela,
-- 	d_up_net45a, d_dn_net45a,
-- 	d_up_net13a, d_dn_net13a,
-- 	d_up_net45, d_dn_net45,
-- 	d_up_d_int, d_dn_d_int,
-- 	d_up_en_latchd, d_dn_en_latchd,
-- 	d_up_en_latchwen, d_dn_en_latchwen,
-- 	d_up_wen_h, d_dn_wen_h,
-- 	d_up_d_h, d_dn_d_h,
-- 
-- 	tHI, tLO
--        in final_reg endhide);
-- 
-- 
-- prints "****************** BAD ******************";
-- 
-- bad_reg := post_reg & loc[observer] = observer_bad
-- 		;
-- 
-- print (hide
-- 	s,
-- 	x_net27,
-- 	x_wela,
-- 	x_net13a,
-- 	x_net45,
-- 	x_d_int,
-- 	x_en_latchd,
-- 	x_en_latchwen,
-- 	x_wen_h,
-- 	x_d_h,
-- 	x_observer
-- 	,
-- 	d_up_q_0,
-- 	d_up_net27,
-- 	d_up_d_inta, d_dn_d_inta,
-- 	d_up_wela, d_dn_wela,
-- 	d_up_net45a, d_dn_net45a,
-- 	d_up_net13a, d_dn_net13a,
-- 	d_up_net45, d_dn_net45,
-- 	d_up_d_int, d_dn_d_int,
-- 	d_up_en_latchd, d_dn_en_latchd,
-- 	d_up_en_latchwen, d_dn_en_latchwen,
-- 	d_up_wen_h, d_dn_wen_h,
-- 	d_up_d_h, d_dn_d_h,
-- 
-- 	tHI, tLO
--        in bad_reg endhide);
-- 
-- prints "****************** GOOD - BAD ******************";
-- 
-- inter_reg := weakdiff(final_reg, bad_reg);
-- 
-- print (hide
-- 	s,
-- 	x_net27,
-- 	x_wela,
-- 	x_net13a,
-- 	x_net45,
-- 	x_d_int,
-- 	x_en_latchd,
-- 	x_en_latchwen,
-- 	x_wen_h,
-- 	x_d_h,
-- 	x_observer
-- 	,
-- 	d_up_q_0,
-- 	d_up_net27,
-- 	d_up_d_inta, d_dn_d_inta,
-- 	d_up_wela, d_dn_wela,
-- 	d_up_net45a, d_dn_net45a,
-- 	d_up_net13a, d_dn_net13a,
-- 	d_up_net45, d_dn_net45,
-- 	d_up_d_int, d_dn_d_int,
-- 	d_up_en_latchd, d_dn_en_latchd,
-- 	d_up_en_latchwen, d_dn_en_latchwen,
-- 	d_up_wen_h, d_dn_wen_h,
-- 	d_up_d_h, d_dn_d_h,
-- 
-- 	tHI, tLO
--        in inter_reg endhide);



prints "****************** INITIAL REG ******************";

print init;

prints "****************** POST* ******************";

post_reg := reach forward from init endreach;

-- print (hide
-- 	s,
-- 	x_net27,
-- 	x_wela,
-- 	x_net13a,
-- 	x_net45,
-- 	x_d_int,
-- 	x_en_latchd,
-- 	x_en_latchwen,
-- 	x_wen_h,
-- 	x_d_h,
-- 	x_observer
-- 	,
-- 	d_up_q_0,
-- 	d_up_net27,
-- 	d_up_d_inta, d_dn_d_inta,
-- 	d_up_wela, d_dn_wela,
-- 	d_up_net45a, d_dn_net45a,
-- 	d_up_net13a, d_dn_net13a,
-- 	d_up_net45, d_dn_net45,
-- 	d_up_d_int, d_dn_d_int,
-- 	d_up_en_latchd, d_dn_en_latchd,
-- 	d_up_en_latchwen, d_dn_en_latchwen,
-- 	d_up_wen_h, d_dn_wen_h,
-- 	d_up_d_h, d_dn_d_h,
-- 
-- 	tHI, tLO
-- 	
--        in post_reg endhide);
	  
post_reg := (hide
	s,
	x_net27,
	x_wela,
	x_net13a,
	x_net45,
	x_d_int,
	x_en_latchd,
	x_en_latchwen,
	x_wen_h,
	x_d_h,
	x_observer
	,
	d_up_q_0,
	d_up_net27,
	d_up_d_inta, d_dn_d_inta,
	d_up_wela, d_dn_wela,
	d_up_net45a, d_dn_net45a,
	d_up_net13a, d_dn_net13a,
	d_up_net45, d_dn_net45,
	d_up_d_int, d_dn_d_int,
	d_up_en_latchd, d_dn_en_latchd,
	d_up_en_latchwen, d_dn_en_latchwen,
	d_up_wen_h, d_dn_wen_h,
	d_up_d_h, d_dn_d_h,

	tHI, tLO
       in post_reg endhide);

-- prints "****************** GOOD ******************";
-- final_reg := post_reg & loc[observer] = observer_good; -- loc[env] = env6;
-- print final_reg;


prints "****************** BAD ******************";
bad_reg := post_reg & loc[observer] = observer_bad ; -- & tsetupd >= 98 & tsetupwen >= 29;
print bad_reg ;

-- prints "****************** GOOD - BAD ******************";
-- inter_reg := weakdiff(final_reg, bad_reg);
-- print inter_reg;
