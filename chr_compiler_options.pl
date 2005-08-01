/*  $Id$

    Part of CHR (Constraint Handling Rules)

    Author:        Tom Schrijvers
    E-mail:        Tom.Schrijvers@cs.kuleuven.ac.be
    WWW:           http://www.swi-prolog.org
    Copyright (C): 2005-2006, K.U. Leuven

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    As a special exception, if you link this library with other files,
    compiled with a Free Software compiler, to produce an executable, this
    library does not by itself cause the resulting executable to be covered
    by the GNU General Public License. This exception does not however
    invalidate any other reasons why the executable file might be covered by
    the GNU General Public License.
*/
:- module(chr_compiler_options,
	[ handle_option/2
	, init_chr_pp_flags/0
	, chr_pp_flag/2
	]).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global Options
%

handle_option(Var,Value) :- 
	var(Var), !,
	format('CHR compiler ERROR: ~w.\n',[option(Var,Value)]),
	format('    `--> First argument should be an atom, not a variable.\n',[]),
	fail.

handle_option(Name,Value) :- 
	var(Value), !,
	format('CHR compiler ERROR: ~w.\n',[option(Name,Value)]),
	format('    `--> Second argument should be a nonvariable.\n',[]),
	fail.

handle_option(Name,Value) :-
	option_definition(Name,Value,Flags),
	!,
	set_chr_pp_flags(Flags).

handle_option(Name,Value) :- 
	\+ option_definition(Name,_,_), !,
	setof(N,_V ^ _F ^ (option_definition(N,_V,_F)),Ns),
	format('CHR compiler WARNING: ~w.\n',[option(Name,Value)]),
	format('    `--> Invalid option name ~w: should be one of ~w.\n',[Name,Ns]).

handle_option(Name,Value) :- 
	findall(V,option_definition(Name,V,_),Vs), 
	format('CHR compiler ERROR: ~w.\n',[option(Name,Value)]),
	format('    `--> Invalid value ~w: should be one of ~w.\n',[Value,Vs]),
	fail.

option_definition(optimize,experimental,Flags) :-
	Flags = [ functional_dependency_analysis  - on,
                  check_unnecessary_active - off,
		  reorder_heads		   - on,
		  set_semantics_rule	   - off,
		  storage_analysis	   - on,
		  guard_via_reschedule     - on,
		  guard_simplification	   - on,
		  check_impossible_rules   - on,
		  occurrence_subsumption   - on,
		  observation		   - on,
		  ai_observation_analysis  - on,
		  late_allocation	   - on,
		  reduced_indexing	   - on
		].
option_definition(optimize,full,Flags) :-
	Flags = [ functional_dependency_analysis  - on,
                  check_unnecessary_active - full,
		  reorder_heads		   - on,
		  set_semantics_rule	   - on,
		  storage_analysis	   - on,
		  guard_via_reschedule     - on,
		  guard_simplification	   - on,
		  check_impossible_rules   - on,
		  occurrence_subsumption   - on,
		  observation		   - on,
		  ai_observation_analysis  - on,
		  late_allocation	   - on,
		  reduced_indexing	   - on
		].

option_definition(optimize,sicstus,Flags) :-
	Flags = [ functional_dependency_analysis  - off,
                  check_unnecessary_active - simplification,
		  reorder_heads		   - off,
		  set_semantics_rule	   - off,
		  storage_analysis	   - off,
		  guard_via_reschedule     - off,
		  guard_simplification	   - off,
		  check_impossible_rules   - off,
		  occurrence_subsumption   - off,
		  observation		   - off,
		  ai_observation_analysis	   - off,
		  late_allocation	   - off,
		  reduced_indexing	   - off
		].

option_definition(optimize,off,Flags) :-
	Flags = [ functional_dependency_analysis  - off,
                  check_unnecessary_active - off,
		  reorder_heads		   - off,
		  set_semantics_rule	   - off,
		  storage_analysis	   - off,
		  guard_via_reschedule     - off,
		  guard_simplification	   - off,
		  check_impossible_rules   - off,
		  occurrence_subsumption   - off,
		  observation		   - off,
		  ai_observation_analysis	   - off,
		  late_allocation	   - off,
		  reduced_indexing	   - off
		].

option_definition(functional_dependency_analysis,on,Flags) :-
	Flags = [ functional_dependency_analysis - on ].
option_definition(functional_dependency_analysis,off,Flags) :-
	Flags = [ functional_dependency_analysis - off ].

option_definition(set_semantics_rule,on,Flags) :-
	Flags = [ set_semantics_rule - on ].
option_definition(set_semantics_rule,off,Flags) :-
	Flags = [ set_semantics_rule - off ].

option_definition(check_unnecessary_active,full,Flags) :-
	Flags = [ check_unnecessary_active - full ].
option_definition(check_unnecessary_active,simplification,Flags) :-
	Flags = [ check_unnecessary_active - simplification ].
option_definition(check_unnecessary_active,off,Flags) :-
	Flags = [ check_unnecessary_active - off ].

option_definition(check_guard_bindings,on,Flags) :-
	Flags = [ guard_locks - on ].
option_definition(check_guard_bindings,off,Flags) :-
	Flags = [ guard_locks - off ].

option_definition(reduced_indexing,on,Flags) :-
	Flags = [ reduced_indexing - on ].
option_definition(reduced_indexing,off,Flags) :-
	Flags = [ reduced_indexing - off ].

option_definition(storage_analysis,on,Flags) :-
	Flags = [ storage_analysis - on ].
option_definition(storage_analysis,off,Flags) :-
	Flags = [ storage_analysis - off ].

option_definition(guard_simplification,on,Flags) :-
	Flags = [ guard_simplification - on ].
option_definition(guard_simplification,off,Flags) :-
	Flags = [ guard_simplification - off ].

option_definition(check_impossible_rules,on,Flags) :-
	Flags = [ check_impossible_rules - on ].
option_definition(check_impossible_rules,off,Flags) :-
	Flags = [ check_impossible_rules - off ].

option_definition(occurrence_subsumption,on,Flags) :-
	Flags = [ occurrence_subsumption - on ].
option_definition(occurrence_subsumption,off,Flags) :-
	Flags = [ occurrence_subsumption - off ].

option_definition(late_allocation,on,Flags) :-
	Flags = [ late_allocation - on ].
option_definition(late_allocation,off,Flags) :-
	Flags = [ late_allocation - off ].

option_definition(type_definition,TypeDef,[]) :-
	( nonvar(TypeDef) ->
	TypeDef = type(T,D),
	chr_translate:type_definition(T,D)
	; true).
option_definition(type_declaration,TypeDecl,[]) :-
	( nonvar(TypeDecl) ->
	functor(TypeDecl,F,A),
	TypeDecl =.. [_|ArgTypes],
	chr_translate:constraint_type(F/A,ArgTypes)
	; true).
	
option_definition(mode,ModeDecl,[]) :-
	( nonvar(ModeDecl) ->
	functor(ModeDecl,F,A),
	ModeDecl =.. [_|ArgModes],
	chr_translate:constraint_mode(F/A,ArgModes)
	; true).
option_definition(store,FA-Store,[]) :-
	chr_translate:store_type(FA,Store).

option_definition(debug,off,Flags) :-
	Flags = [ debugable - off ].
option_definition(debug,on,Flags) :-
	Flags = [ debugable - on ].

option_definition(store_counter,off,[]).
option_definition(store_counter,on,[store_counter-on]).

option_definition(observation,off,Flags) :-
	Flags = [
			observation_analysis - off,
			ai_observation_analysis - off,
			late_allocation - off,
			storage_analysis - off
		].
option_definition(observation,on,Flags) :-
	Flags = [
			observation_analysis - on,
			ai_observation_analysis - on
		].
option_definition(observation,regular,Flags) :-
	Flags = [
			observation_analysis - on,
			ai_observation_analysis - off
		].
option_definition(observation,ai,Flags) :-
	Flags = [
			observation_analysis - off,
			ai_observation_analysis - on
		].

option_definition(solver_events,NMod,Flags) :-
	Flags =	[solver_events - NMod].

init_chr_pp_flags :-
	chr_pp_flag_definition(Name,[DefaultValue|_]),
	set_chr_pp_flag(Name,DefaultValue),
	fail.
init_chr_pp_flags.		

set_chr_pp_flags([]).
set_chr_pp_flags([Name-Value|Flags]) :-
	set_chr_pp_flag(Name,Value),
	set_chr_pp_flags(Flags).

set_chr_pp_flag(Name,Value) :-
	atom_concat('$chr_pp_',Name,GlobalVar),
	nb_setval(GlobalVar,Value).

chr_pp_flag_definition(functional_dependency_analysis,[off,on]).
chr_pp_flag_definition(check_unnecessary_active,[off,full,simplification]).
chr_pp_flag_definition(reorder_heads,[off,on]).
chr_pp_flag_definition(set_semantics_rule,[off,on]).
chr_pp_flag_definition(guard_via_reschedule,[off,on]).
chr_pp_flag_definition(guard_locks,[on,off]).
chr_pp_flag_definition(storage_analysis,[off,on]).
chr_pp_flag_definition(debugable,[on,off]).
chr_pp_flag_definition(reduced_indexing,[off,on]).
chr_pp_flag_definition(observation_analysis,[off,on]).
chr_pp_flag_definition(ai_observation_analysis,[off,on]).
chr_pp_flag_definition(late_allocation,[off,on]).
chr_pp_flag_definition(store_counter,[off,on]).
chr_pp_flag_definition(guard_simplification,[off,on]).
chr_pp_flag_definition(check_impossible_rules,[off,on]).
chr_pp_flag_definition(occurrence_subsumption,[off,on]).
chr_pp_flag_definition(observation,[off,on]).
chr_pp_flag_definition(show,[off,on]).
chr_pp_flag_definition(solver_events,[none,_]).

chr_pp_flag(Name,Value) :-
	atom_concat('$chr_pp_',Name,GlobalVar),
	nb_getval(GlobalVar,V),
	( V == [] ->
		chr_pp_flag_definition(Name,[Value|_])
	;
		V = Value
	).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%