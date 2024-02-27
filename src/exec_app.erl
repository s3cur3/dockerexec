%%%------------------------------------------------------------------------
%%% File: $Id$
%%%------------------------------------------------------------------------
%%% @doc     This module implements application and supervisor behaviors
%%%          of the `exec' application.
%%% @author  Serge Aleynikov <saleyn@gmail.com>
%%% @version $Revision: 1.1 $
%%% @end
%%%----------------------------------------------------------------------
%%% Created: 2003-06-25 by Serge Aleynikov <saleyn@gmail.com>
%%% $URL$
%%%------------------------------------------------------------------------
-module(exec_app).
-author('saleyn@gmail.com').
-id("$Id$").

-behaviour(application).
-behaviour(supervisor).

%% application and supervisor callbacks
-export([start/2, stop/1, init/1]).

%%%----------------------------------------------------------------------
%%% API
%%%----------------------------------------------------------------------

%%----------------------------------------------------------------------
%% This is the entry module for your application. It contains the
%% start function and some other stuff. You identify this module
%% using the 'mod' attribute in the .app file.
%%
%% The start function is called by the application controller.
%% It normally returns {ok,Pid}, i.e. the same as gen_server and
%% supervisor. Here, we simply call the start function in our supervisor.
%% One can also return {ok, Pid, State}, where State is reused in stop(State).
%%
%% Type can be 'normal' or {takeover,FromNode}. If the 'start_phases'
%% attribute is present in the .app file, Type can also be {failover,FromNode}.
%% This is an odd compatibility thing.
%% @private
%%----------------------------------------------------------------------
start(_Type, _Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%----------------------------------------------------------------------
%% stop(State) is called when the application has been terminated, and
%% all processes are gone. The return value is ignored.
%% @private
%%----------------------------------------------------------------------
stop(_S) ->
    ok.

%%%---------------------------------------------------------------------
%%% Supervisor behaviour callbacks
%%%---------------------------------------------------------------------

%% @private
init([]) ->
    Options =
        lists:foldl(
            fun(I, Acc) -> add_option(I, Acc) end,
            [],
            [I || {I, _} <- exec:default()]
        ),
    {ok, {
        % Allow MaxR restarts within MaxT seconds
        {one_for_one, 3, 30},
        % Id       = internal id
        [
            {exec,
                % StartFun = {M, F, A}
                {exec, start_link, [Options]},
                % Restart  = permanent | transient | temporary
                permanent,
                % Shutdown - wait 10 seconds, to give child processes time to be killed off.
                10000,
                % Type     = worker | supervisor
                worker,
                % Modules  = [Module] | dynamic
                [exec]}
        ]
    }}.

add_option(Option, Acc) ->
    case application:get_env(dockerexec, Option) of
        {ok, Value} -> [{Option, Value} | Acc];
        undefined -> Acc
    end.
