------------------------------------------Handler------------------------------------------


--Assumption: Atmost up_req and down_req from 1 floor
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--reset goes directly to the controllers

ENTITY handler IS
PORT (floor_status1, floor_status2: IN std_logic_vector(3 DOWNTO 0); --this and the input below define curr status of both lifts
      dir_status1, dir_status2: IN std_logic_vector(1 DOWNTO 0);
      clk: IN std_logic;
      reset: IN std_logic;
      up_request, down_request: IN std_logic_vector(3 DOWNTO 0);
      lift_req1, lift_req2: OUT std_logic_vector(3 DOWNTO 0));
END handler;



ARCHITECTURE handler_logic OF handler IS
  signal UpReqUp, UpReqDown, DownReqUp, DownReqDown: std_logic_vector(3 DOWNTO 0); --dir_status got nothing to do with this classification!!
  signal set: std_logic;
  signal check_up_request, check_down_request: std_logic;
  signal check_floor_status1, check_floor_status2: std_logic_vector(3 DOWNTO 0); --this and the input below define curr status of both lifts
BEGIN
  PROCESS(clk, reset)
  BEGIN
    IF rising_edge(clk) AND reset = '1' THEN
      UpReqUp <= "0000";
      DownReqUp <= "0000";
      UpReqDown <= "0000";
      DownReqDown <= "0000";
      check_up_request <= "0000";
      check_down_request <= "0000";
      check_floor_status1 <= "0000";
      check_floor_status2 <= "0000";
      set <= '1';
    END IF;
  END PROCESS;

  PROCESS(clk)
    IF rising_edge(clk) AND set = '1' THEN
      --first assign requests of up_requests.
      --here write assignment statements of uprequp and downreqdown
      IF (dir_status1 = "01" OR dir_status2 = "01") THEN
          IF floor_status1 = "0001" THEN  --assign same floor requests too
            lift_req1 <= UpReqUp(3 DOWNTO 0);
            UpReqUp(3 DOWNTO 1) <= "0000";
          ELSIF floor_status1 = "0010" THEN
            lift_req1 <= UpReqUp(3 DOWNTO 1);
            UpReqUp(3 DOWNTO 2) <= "000";
          ELSIF floor_status1 = "0100" THEN
            lift_req1 <= UpReqUp(3 DOWNTO 2);
            UpReqUp(3 DOWNTO 3) <= "00";
          END IF;
        ELSIF dir_status2 = "01" THEN
          IF floor_status2 = "0001" THEN  --assign same floor requests too
            lift_req2 <= UpReqUp(3 DOWNTO 0);
            UpReqUp(3 DOWNTO 1) <= "0000";
          ELSIF floor_status2 = "0010" THEN
            lift_req2 <= UpReqUp(3 DOWNTO 1);
            UpReqUp(3 DOWNTO 2) <= "000";
          ELSIF floor_status2 = "0100" THEN
            lift_req2 <= UpReqUp(3 DOWNTO 2);
            UpReqUp(3 DOWNTO 3) <= "00";
         END IF;
      IF (dir_status1 = "10" OR dir_status2 = "10") THEN
        IF dir_status1 = "10" THEN  
          IF floor_status1 = "0010" THEN
            lift_req1 <= DownReqDown(1 DOWNTO 0);
            DownReqDown(1 DOWNTO 0); <= "00";
          ELSIF floor_status1 = "0100" THEN
            lift_req1 <= DownReqDown(2 DOWNTO 0);
            DownReqDown(2 DOWNTO 0) <= "000";
          ELSIF floor_status1 = "1000" THEN
            lift_req1 <= DownReqDown(3 DOWNTO 0);
            DownReqDown(3 DOWNTO 0) <= "0000";
          END IF;
        ELSIF dir_status2 = "10" THEN
          IF floor_status2 = "0010" THEN
            lift_req2 <= DownReqDown(1 DOWNTO 0);
            DownReqDown(1 DOWNTO 0); <= "00";
          ELSIF floor_status2= "0100" THEN
            lift_req2 <= DownReqDown(2 DOWNTO 0);
            DownReqDown(2 DOWNTO 0) <= "000";
          ELSIF floor_status2 = "1000" THEN
            lift_req2 <= DownReqDown(3 DOWNTO 0);
            DownReqDown(3 DOWNTO 0) <= "0000";
          END IF;
      IF (dir_status1 = "00" OR dir_status2 = "00") THEN --little tricky
        IF dir_status1 = "00" THEN
          IF floor_status1 = "0001" THEN
            IF UpReqUp /= "0000" THEN
              lift_req1 <= UpReqUp;
              UpReqUp <= "0000";
            ELSIF UpReqDown /= "0000" THEN
              lift_req1 <= UpReqDown;
              UpReqDown <= "0000";
            ELSIF DownReqUp /= "0000" THEN
              lift_req1 <= DownReqUp;
              DownReqUp <= "0000";
            ELSIF DownReqDown <= "0000" THEN
              lift_req1 <= DownReqDown;
              DownReqDown <= "0000";
            END IF;
          ELSIF floor_status1 = "0010" THEN 
            IF UpReqUp(3 DOWNTO 1) /= "000" THEN
              lift_req1(3 DOWNTO 1) <= UpReqUp(3 DOWNTO 1);
              UpReqUp(3 DOWNTO 1) <= "000";
            ELSIF UpReqDown(3 DOWNTO 1) /= "000" THEN
              lift_req1(3 DOWNTO 1) <= UpReqDown(3 DOWNTO 1);
              UpReqDown(3 DOWNTO 1) <= "000";
            ELSIF DownReqUp(3 DOWNTO 1) /= "000" THEN
              lift_req1(3 DOWNTO 1) <= DownReqUp(3 DOWNTO 1);
              DownReqUp(3 DOWNTO 1) <= "000";
            ELSIF DownReqDown(3 DOWNTO 1) <= "000" THEN
              lift_req1(3 DOWNTO 1) <= DownReqDown(3 DOWNTO 1);
              DownReqDown(3 DOWNTO 1) <= "000";
            END IF;
          ELSIF floor_status1 = "0100" THEN
            IF UpReqUp(3 DOWNTO 2) /= "00" THEN
              lift_req1(3 DOWNTO 2) <= UpReqUp(3 DOWNTO 2);
              UpReqUp(3 DOWNTO 2) <= "00";
            ELSIF UpReqDown(3 DOWNTO 2) /= "00" THEN
              lift_req1(3 DOWNTO 2) <= UpReqDown(3 DOWNTO 2);
              UpReqDown(3 DOWNTO 2) <= "00";
            ELSIF DownReqUp(3 DOWNTO 2) /= "00" THEN
              lift_req1(3 DOWNTO 2) <= DownReqUp(3 DOWNTO 2);
              DownReqUp(3 DOWNTO 2) <= "00";
            ELSIF DownReqDown(3 DOWNTO 2) <= "00" THEN
              lift_req1(3 DOWNTO 2) <= DownReqDown(3 DOWNTO 2);
              DownReqDown(3 DOWNTO 2) <= "00";
            END IF;
          ELSIF floor_status1 = "1000" THEN
            IF UpReqUp(3 DOWNTO 3) /= '0' THEN
              lift_req1(3 DOWNTO 3) <= UpReqUp(3 DOWNTO 3);
              UpReqUp(3 DOWNTO 3) <= '0';
            ELSIF UpReqDown(3 DOWNTO 3) /= '0' THEN
              lift_req1(3 DOWNTO 3) <= UpReqDown(3 DOWNTO 3);
              UpReqDown(3 DOWNTO 3) <= '0';
            ELSIF DownReqUp(3 DOWNTO 3) /= '0' THEN
              lift_req1(3 DOWNTO 3) <= DownReqUp(3 DOWNTO 3);
              DownReqUp(3 DOWNTO 3) <= '0';
            ELSIF DownReqDown(3 DOWNTO 3) <= '0' THEN
              lift_req1(3 DOWNTO 3) <= DownReqDown(3 DOWNTO 3);
              DownReqDown(3 DOWNTO 3) <= '0';
            END IF;
          END IF;
        ELSIF dir_status2 = "00" THEN
          IF floor_status2 = "0001" THEN
            IF UpReqUp /= "0000" THEN
              lift_req2 <= UpReqUp;
              UpReqUp <= "0000";
            ELSIF UpReqDown /= "0000" THEN
              lift_req2 <= UpReqDown;
              UpReqDown <= "0000";
            ELSIF DownReqUp /= "0000" THEN
              lift_req2 <= DownReqUp;
              DownReqUp <= "0000";
            ELSIF DownReqDown <= "0000" THEN
              lift_req2 <= DownReqDown;
              DownReqDown <= "0000";
            END IF;
          ELSIF floor_status2 = "0010" THEN 
            IF UpReqUp(3 DOWNTO 1) /= "000" THEN
              lift_req2(3 DOWNTO 1) <= UpReqUp(3 DOWNTO 1);
              UpReqUp(3 DOWNTO 1) <= "000";
            ELSIF UpReqDown(3 DOWNTO 1) /= "000" THEN
              lift_req2(3 DOWNTO 1) <= UpReqDown(3 DOWNTO 1);
              UpReqDown(3 DOWNTO 1) <= "000";
            ELSIF DownReqUp(3 DOWNTO 1) /= "000" THEN
              lift_req2(3 DOWNTO 1) <= DownReqUp(3 DOWNTO 1);
              DownReqUp(3 DOWNTO 1) <= "000";
            ELSIF DownReqDown(3 DOWNTO 1) <= "000" THEN
              lift_req2(3 DOWNTO 1) <= DownReqDown(3 DOWNTO 1);
              DownReqDown(3 DOWNTO 1) <= "000";
            END IF;
          ELSIF floor_status2 = "0100" THEN
            IF UpReqUp(3 DOWNTO 2) /= "00" THEN
              lift_req2(3 DOWNTO 2) <= UpReqUp(3 DOWNTO 2);
              UpReqUp(3 DOWNTO 2) <= "00";
            ELSIF UpReqDown(3 DOWNTO 2) /= "00" THEN
              lift_req2(3 DOWNTO 2) <= UpReqDown(3 DOWNTO 2);
              UpReqDown(3 DOWNTO 2) <= "00";
            ELSIF DownReqUp(3 DOWNTO 2) /= "00" THEN
              lift_req2(3 DOWNTO 2) <= DownReqUp(3 DOWNTO 2);
              DownReqUp(3 DOWNTO 2) <= "00";
            ELSIF DownReqDown(3 DOWNTO 2) <= "00" THEN
              lift_req2(3 DOWNTO 2) <= DownReqDown(3 DOWNTO 2);
              DownReqDown(3 DOWNTO 2) <= "00";
            END IF;
          ELSIF floor_status2 = "1000" THEN
            IF UpReqUp(3 DOWNTO 3) /= '0' THEN
              lift_req2(3 DOWNTO 3) <= UpReqUp(3 DOWNTO 3);
              UpReqUp(3 DOWNTO 3) <= '0';
            ELSIF UpReqDown(3 DOWNTO 3) /= '0' THEN
              lift_req2(3 DOWNTO 3) <= UpReqDown(3 DOWNTO 3);
              UpReqDown(3 DOWNTO 3) <= '0';
            ELSIF DownReqUp(3 DOWNTO 3) /= '0' THEN
              lift_req2(3 DOWNTO 3) <= DownReqUp(3 DOWNTO 3);
              DownReqUp(3 DOWNTO 3) <= '0';
            ELSIF DownReqDown(3 DOWNTO 3) <= '0' THEN
              lift_req2(3 DOWNTO 3) <= DownReqDown(3 DOWNTO 3);
              DownReqDown(3 DOWNTO 3) <= '0';
            END IF;
          END IF;
        END IF;
      END IF;
      --assignment over
      IF check_up_request /= up_request THEN --new request made. Update
        check_up_request <= up_request;
        IF (up_request > floor_status1) OR (up_request > floor_status2) THEN -- Case of UpReqUp
          UpReqUp <= UpReqUp OR up_request;
        ELSE
          UpReqDown <= UpReqDown OR up_request;
        END IF;
      END IF;
      IF check_down_request /= down_request THEN --new request made. Update
        check_down_request <= down_request;
        IF (down_request <= floor_status1) OR (down_request <= floor_status2) THEN -- Case of DownReqDown
          DownReqDown <= DownReqDown OR down_request;
        ELSE
          DownReqDown <= DownReqDown OR down_request;
        END IF;
      END IF;    
      IF(check_floor_status1 /= floor_status1) THEN --floor of lift 1 changed. 
        IF(check_floor_status1 > floor_status1) THEN --lift is going down. So, DownReqUp may have changed to UpReqUp resp.
          IF check_floor_status1 = "0010" THEN --can't be 0001
            UpReqUp(1) <= DownReqUp(1);
            DownReqUp(1) <= '0';
          ELSIF check_floor_status1 = "0100" THEN 
            UpReqUp(2) <= DownReqUp(2);
            DownReqUp(2) <= '0';
          ELSIF check_floor_status1 = "1000" THEN 
            UpReqUp(3) <= DownReqUp(3); --no sense but let it be
            DownReqUp(3) <= '0';
          END IF;
        ELSE --lift is going up. So, UpReqDown may have changed to DownReqDown resp.
          IF check_floor_status1 = "0001" THEN
            DownReqDown(0) <= UpReqDown(0); ----no sense but let it be
            UpReqDown(0) <= '0';
          ELSIF check_floor_status1 = "0010" THEN 
            DownReqDown(1) <= UpReqDown(1);
            UpReqDown(1) <= '0';
          ELSIF check_floor_status1 = "0100" THEN --can't be 1000
            DownReqDown(2) <= UpReqDown(2);
            UpReqDown(2) <= '0';
          END IF;
        END IF;
        check_floor_status1 <= floor_status1;
      ELSIF (check_floor_status2 /= floor_status2) THEN 
        IF(check_floor_status2 > floor_status2) THEN --lift is going down. So, DownReqUp may have changed to UpReqUp resp.
          IF check_floor_status2 = "0010" THEN --can't be 0001
            UpReqUp(1) <= DownReqUp(1);
            DownReqUp(1) <= '0';
          ELSIF check_floor_status2 = "0100" THEN 
            UpReqUp(2) <= DownReqUp(2);
            DownReqUp(2) <= '0';
          ELSIF check_floor_status2 = "1000" THEN 
            UpReqUp(3) <= DownReqUp(3); --no sense but let it be
            DownReqUp(3) <= '0';
          END IF;
        ELSE --lift is going up. So, UpReqDown may have changed to DownReqDown resp.
          IF check_floor_status2 = "0001" THEN --Note: Same floor request is DownReqUp/DownReqDown
            DownReqDown(0) <= UpReqDown(0); ----no sense but let it be
            DownReqDown(1) <= UpReqDown(1); ----no sense but let it be
            UpReqDown(1 DOWNTO 0) <= "00";
          ELSIF check_floor_status2 = "0010" THEN 
            DownReqDown(1) <= UpReqDown(1);
            DownReqDown(2) <= UpReqDown(2);
            UpReqDown(2 DOWNTO 1) <= "00";
          ELSIF check_floor_status2 = "0100" THEN --can't be 1000
            DownReqDown(2) <= UpReqDown(2);
            DownReqDown(3) <= UpReqDown(3);
            UpReqDown(3 DOWNTO 2) <= "00";
          END IF;
        END IF;
        check_floor_status2 <= floor_status2;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE handler_logic;


-----------------------------------------------Controller-----------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controller IS
PORT (reset: IN std_logic,
      handler_req: IN std_logic_vector(3 DOWNTO 0);
      lift_req: IN std_logic_vector(3 DOWNTO 0);
      clk: IN std_logic;
      door_open_req: IN std_logic;
      door_close_req: IN std_logic;
      door_status: OUT std_logic;
      floor_status: OUT std_logic_vector(3 DOWNTO 0);
      dir_status: OUT std_logic_vector(1 DOWNTO 0));
END controller;


ARCHITECTURE controller_logic OF controller IS
  signal cur_floor, stops: std_logic_vector(3 DOWNTO 0); --stops is floors where lift has to stop.
  signal cur_dir: std_logic_vector(1 DOWNTO 0); --direction covers the current state of lift. It can be idle (00), go up(01) or go down(10)
  signal door_stat: std_logic; --0 means open, 1 means closed.
  signal check_floor_handler, check_floor_lift: std_logic_vector(3 DOWNTO 0);
  signal floor_transit, door_open, door_close: integer; --door_weight signal combined with door_close by increasing counter limit
  signal is_door_open_req, is_door_close_req: std_logic;
  signal set: std_logic; -- unless this is '1', nothing happens. is set '1' once we hit reset the very first time we begin simulation
BEGIN
  PROCESS(clk, reset) --reset to initial state. 
  BEGIN
    IF rising_edge(clk) AND reset = '1' THEN
      set <= '1';
      check_floor_handler <= "0000";
      check_floor_lift <= "0000";
      cur_floor <= "0000";
      stops <= "0000";
      cur_dir <= "00";
      door_stat <= '1'; --door is open
      floor_transit <= 0;
      door_open <= 0;
      door_close <= 0;
    END IF;
  END PROCESS;

  PROCESS(clk)
  BEGIN
    IF set = '1' AND rising_edge(clk) THEN --only if set = '1' does this execute on rising edge
      floor_status <= cur_floor; --give the current floor status to the SSD and the handler
      dir_status <= cur_dir;  ----give the current direction status to the SSD and the handler.
      door_status <= door_stat;
      IF handler_req /= check_floor_req THEN --Store the handler request. This method saves one clock cycle
        stops <= stops OR handler_req;
        check_floor_req <= handler_req;
      END IF;
      IF lift_req /= check_lift_req THEN --Store the inside lift request. This method saves one clock cycle
        stops <= stops OR lift_req;
        check_lift_req <= lift_req;
      END IF;
      IF door_open_req = '1' THEN --Save this pulse
        is_door_open_req <= door_open_req;
      END IF;
      IF door_close_req = '1' THEN --Save this pulse
        is_door_close_req <= door_close_req;
      END IF;
      --start handling the different scenarios
      IF cur_status = "00" THEN --Lift is idle.
        IF stops = "0000" THEN --No stops, so just open the door of the lift 
          IF door_stat = '0' THEN --In case door is closed do nothing if door close request. if door open request, be sure door open in 0.1 sec.
            IF is_door_open_req = '1' THEN --if we want door to open fast
              IF door_open < 285 THEN --speed up the counter to 361-0.1*763 if it's less than that (so it takes at max 0.1 sec)
                door_open = 285;
              END IF;
              is_door_open_req <= '0'; --not needed any further
            ELSE
              IF door_open = 361 THEN --regular counting now
                door_stat <= '1';
                door_open <= 0;
              ELSE
                door_open <= door_open + 1;
              END IF;
            END IF;
          --Since there are no requests (stops = "0000") if doors are open they won't close even if we push the close door button. 
          END IF;
        ELSIF stops /= "0000" THEN --if the lift was idle, and there are stops then first see if the doors are even open or not
          IF door_stat = '1' THEN --if doors are open, and stops are there, check if current floor has a stop or not. In case it gets a stop request while lift door is still closing then open the door again.
            IF((cur_floor AND stops) /= "0000") THEN --keep this case simple to avoid unnecessary complications. just reset door close counter
              door_close <= 0;
              stops <= (stops XOR cur_floor); --request for this floor was executed
            ELSE -- if no request from this floor close the door
              IF is_door_open_req = '1' THEN
                IF door_close <= 763 THEN --1 sec hasn't passed, that is door is supposedly still open
                  door_close <= 0; --just reset the counter.
                ELSE
                  door_close <= -76; -- make counter -0.1sec, so that now we are accounting for the 0.1 s lag needed for closing the door.
                END IF;
                is_door_open_req <= '0';
                is_door_close_req <= '0'; --so open request is supposed to override close request
              ELSIF is_door_close_req = '1' THEN
                IF door_close < 763
                  door_close = 763; --speed up the counter to 1sec, so that last 0.5 sec is for the closing time.
                END IF;
                is_door_close_req <= '0';
              ELSE
                IF door_close = 1124 THEN
                  door_stat <= '0';
                  door_close <= 0;
                ELSE
                  door_close <= door_close + 1;
              END IF;
            END IF;
          ELSIF door_stat = '0' THEN --if door is closed, check if there is any request on the same floor.
            IF((cur_floor AND stops) /= "0000") THEN --means there is a request on this floor! open the door
              IF is_door_open_req = '1' THEN --if we want door to open fast
                IF door_open < 285 THEN --speed up the counter to 361-0.1*763 if it's less than that (so it takes at max 0.1 sec)
                  door_open = 285;
                END IF;
                is_door_open_req <= '0'; --not needed any further
              ELSE
                IF door_open = 361 THEN --regular counting now
                  door_stat <= '1';
                  door_open <= 0;
                  stops <= (stops XOR cur_floor); --request for this floor was executed
                ELSE
                  door_open <= door_open + 1;
                END IF;
              END IF;
            ELSE --if there are stops (not on this floor), lift is IDLE and door is closed it means it is about to leave. Decide next state
              IF cur_floor = "0001" THEN
                cur_status = "01";
              ELSIF cur_floor = "0010" THEN
                IF stops(3 DOWNTO 2) /= "00" THEN
                  cur_status = "01";
                ELSE
                  cur_status = "10";
                END IF;
              ELSIF cur_floor = "0100" THEN
                IF stops(3) /= '0' THEN
                  cur_status = "01";
                ELSE
                  cur_status = "10";
                END IF;
              ELSIF cur_floor = "1000" THEN
                cur_status = "10"; 
              END IF;
            END IF;
          END IF;
        END IF;
--IDLE case is supposedly handled, will be checked in simulation
      ELSIF cur_status = "01" THEN --going up!
        IF stops = "0000" OR cur_floor = "1000" THEN --Lift was in going up status but since no stops left, change status to IDLE. IDLE case handles door opening. IDLE true also when reached top
          cur_status = "00";
        ELSIF stops /= "0000" THEN --It's going up, and has some stops remaining
          IF door_stat = '1' --Door is open on this floor and there are stops left. Check if there is pending request on this floor
            IF((cur_floor AND stops) /= "0000") THEN --keep this case simple to avoid unnecessary complications. just reset door close counter
              door_close <= 0;
              stops <= (stops XOR cur_floor); --request for this floor was executed
            ELSE -- no request means close the door
              IF is_door_open_req = '1' THEN
                IF door_close <= 763 THEN --1 sec hasn't passed, that is door is supposedly still open
                  door_close <= 0; --just reset the counter.
                ELSE
                  door_close <= -76; -- make counter -0.1sec, so that now we are accounting for the 0.1 s lag needed for closing the door.
                END IF;
                is_door_open_req <= '0';
                is_door_close_req <= '0'; --so open request is supposed to override close request
              ELSIF is_door_close_req = '1' THEN
                IF door_close < 763
                  door_close = 763; --speed up the counter to 1sec, so that last 0.5 sec is for the closing time.
                END IF;
                is_door_close_req <= '0';
              ELSE
                IF door_close = 1124 THEN
                  door_stat <= '0';
                  door_close <= 0;
                ELSE
                  door_close <= door_close + 1;
              END IF;
            END IF;
          ELSIF door_stat = '0' THEN --if door is closed, check if there is any request on the same floor AND also if this floor hasn't been left already.    
            IF((cur_floor AND stops) /= "0000" AND floor_transit = 0) THEN --This floor is a stop, and this floor hasn't been left yet.
              IF is_door_open_req = '1' THEN --if we want door to open fast
                IF door_open < 285 THEN --speed up the counter to 361-0.1*763 if it's less than that (so it takes at max 0.1 sec)
                  door_open = 285;
                END IF;
                is_door_open_req <= '0'; --not needed any further
              ELSE
                IF door_open = 361 THEN --regular counting now
                  door_stat <= '1';
                  door_open <= 0;
                  stops <= (stops XOR cur_floor); --request for this floor was executed
                ELSE
                  door_open <= door_open + 1;
                END IF;
              END IF; 
            ELSE  --If either this floor isn't a stop, OR this floor has been passed (floor_transit > 0) then 
              IF floor_transit = 1526 THEN --2 secs are up. next floor reached
                IF cur_floor = "0001" THEN
                  cur_floor <= "0010";
                ELSIF cur_floor = "0010" THEN
                  cur_floor <= "0100"; 
                ELSIF cur_floor = "0100" THEN
                  cur_floor <= "1000";
                END IF; --if cur_floor = "1000" then it can't go up. lift goes IDLE
                floor_transit <= 0;
              ELSE
                floor_transit <= floor_transit + 1;
              END IF;
            END IF;
          END IF;
        END IF;
--reqUp state completed. simulation left

      ELSIF cur_status = "10" THEN --lift going down
        IF stops = "0000" OR cur_floor = "0001" THEN --Lift was in going down status but since no stops left, change status to IDLE. IDLE case handles door opening. IDLE true also when reached bottom
          cur_status = "00";
        ELSIF stops /= "0000" THEN --It's going down, and has some stops remaining
          IF door_stat = '1' --Door is open on this floor and there are stops left. Check if there is pending request on this floor
            IF((cur_floor AND stops) /= "0000") THEN --keep this case simple to avoid unnecessary complications. just reset door close counter
              door_close <= 0;
              stops <= (stops XOR cur_floor); --request for this floor was executed
            ELSE -- no request means close the door
              IF is_door_open_req = '1' THEN
                IF door_close <= 763 THEN --1 sec hasn't passed, that is door is supposedly still open
                  door_close <= 0; --just reset the counter.
                ELSE
                  door_close <= -76; -- make counter -0.1sec, so that now we are accounting for the 0.1 s lag needed for closing the door.
                END IF;
                is_door_open_req <= '0';
                is_door_close_req <= '0'; --so open request is supposed to override close request
              ELSIF is_door_close_req = '1' THEN
                IF door_close < 763
                  door_close = 763; --speed up the counter to 1sec, so that last 0.5 sec is for the closing time.
                END IF;
                is_door_close_req <= '0';
              ELSE
                IF door_close = 1124 THEN
                  door_stat <= '0';
                  door_close <= 0;
                ELSE
                  door_close <= door_close + 1;
              END IF;
            END IF;
          ELSIF door_stat = '0' THEN --if door is closed, check if there is any request on the same floor AND also if this floor hasn't been left already.    
            IF((cur_floor AND stops) /= "0000" AND floor_transit = 0) THEN --This floor is a stop, and this floor hasn't been left yet.
              IF is_door_open_req = '1' THEN --if we want door to open fast
                IF door_open < 285 THEN --speed up the counter to 361-0.1*763 if it's less than that (so it takes at max 0.1 sec)
                  door_open = 285;
                END IF;
                is_door_open_req <= '0'; --not needed any further
              ELSE
                IF door_open = 361 THEN --regular counting now
                  door_stat <= '1';
                  door_open <= 0;
                  stops <= (stops XOR cur_floor); --request for this floor was executed
                ELSE
                  door_open <= door_open + 1;
                END IF;
              END IF; 
            ELSE  --If either this floor isn't a stop, OR this floor has been passed (floor_transit > 0) then 
              IF floor_transit = 1526 THEN --2 secs are up. next floor reached
                IF cur_floor = "0001" THEN
                  cur_floor <= "0010";
                ELSIF cur_floor = "0010" THEN
                  cur_floor <= "0100"; 
                ELSIF cur_floor = "0100" THEN
                  cur_floor <= "1000";
                END IF; --if cur_floor = "1000" then it can't go up. lift goes IDLE
                floor_transit <= 0;
              ELSE
                floor_transit <= floor_transit + 1;
              END IF;
            END IF;
          END IF;
        END IF;
      END IF; 
    END IF;
  END PROCESS;
END ARCHITECTURE controller_logic;
