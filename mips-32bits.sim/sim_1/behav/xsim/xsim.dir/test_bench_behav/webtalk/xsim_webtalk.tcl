webtalk_init -webtalk_dir /home/bruna/mips-32bits/mips-32bits.sim/sim_1/behav/xsim/xsim.dir/test_bench_behav/webtalk/
webtalk_register_client -client project
webtalk_add_data -client project -key date_generated -value "Sun Sep  3 10:54:48 2023" -context "software_version_and_target_device"
webtalk_add_data -client project -key product_version -value "XSIM v2020.2 (64-bit)" -context "software_version_and_target_device"
webtalk_add_data -client project -key build_version -value "3064766" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_platform -value "LIN64" -context "software_version_and_target_device"
webtalk_add_data -client project -key registration_id -value "" -context "software_version_and_target_device"
webtalk_add_data -client project -key tool_flow -value "xsim_vivado" -context "software_version_and_target_device"
webtalk_add_data -client project -key beta -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key route_design -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_family -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_device -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_package -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_speed -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key random_id -value "4eaa3e77-0990-4c3c-9439-e1d32e41ec4f" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_id -value "e1505db9b8e84491b2a2a28a18d05acb" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_iteration -value "3" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_name -value "Ubuntu" -context "user_environment"
webtalk_add_data -client project -key os_release -value "Ubuntu 22.04.3 LTS" -context "user_environment"
webtalk_add_data -client project -key cpu_name -value "Intel(R) Core(TM) i7-1065G7 CPU @ 1.30GHz" -context "user_environment"
webtalk_add_data -client project -key cpu_speed -value "1466.345 MHz" -context "user_environment"
webtalk_add_data -client project -key total_processors -value "1" -context "user_environment"
webtalk_add_data -client project -key system_ram -value "16.000 GB" -context "user_environment"
webtalk_register_client -client xsim
webtalk_add_data -client xsim -key Command -value "xsim" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key trace_waveform -value "true" -context "xsim\\usage"
webtalk_add_data -client xsim -key runtime -value "1 us" -context "xsim\\usage"
webtalk_add_data -client xsim -key iteration -value "1" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Time -value "0.03_sec" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Memory -value "123372_KB" -context "xsim\\usage"
webtalk_transmit -clientid 3686217990 -regid "" -xml /home/bruna/mips-32bits/mips-32bits.sim/sim_1/behav/xsim/xsim.dir/test_bench_behav/webtalk/usage_statistics_ext_xsim.xml -html /home/bruna/mips-32bits/mips-32bits.sim/sim_1/behav/xsim/xsim.dir/test_bench_behav/webtalk/usage_statistics_ext_xsim.html -wdm /home/bruna/mips-32bits/mips-32bits.sim/sim_1/behav/xsim/xsim.dir/test_bench_behav/webtalk/usage_statistics_ext_xsim.wdm -intro "<H3>XSIM Usage Report</H3><BR>"
webtalk_terminate
