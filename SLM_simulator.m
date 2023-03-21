answer = questdlg('Start recording?', ...
	'Recording','Yes','No','Yes');
start(obj);

switch answer
    case 'Yes'
        % % Import SDK:
        add_heds_path;
        % Check if the installed SDK supports the required API version
        heds_requires_version(3);
        % Make some enumerations available locally to avoid too much code:
        heds_types;
        % Detect SLMs and open a window on the selected SLM:
        heds_slm_init;
        % Open the SLM preview window in non-scaled mode:
        % This might have an impact on performance, especially in "Capture SLM screen" mode.
        % Please adapt the file show_slm_preview.m if preview window is not at the right position or even not visible.
        show_slm_preview(1.0);
        
        % Output and input folders
        input_folder = 'C:\Users\Machine\Desktop\Test speckle\';
        output_folder = 'C:\Users\Machine\Desktop\Output SLM data\';
        % File extention 
        file_extention = '.bmp';
        
        time_delay = 0.5;
        
        wavelength_nm = 532.0;  % wavelength of incident laser light
        steering_angle_x_deg = 0.2;
        steering_angle_y_deg = -0.3;
        focal_length_mm = 200.0;
        
        for i = 1:10
            input_file_name = strcat(input_folder, int2str(i), file_extention);   
            heds_show_data_fromfile(input_file_name)
            pause(0.1);  
            trigger(vid);
            img = getdata(vid); 
            pause(time_delay - 0.1);
            output_file_name = strcat(output_folder,int2str(i), file_extention);
            imwrite(img, output_file_name);
            disp(output_file_name);
        end
        close all
        f = msgbox("Recording Finished");

    case 'No'
        f = msgbox("Recording cancelled");
        delete(obj)
        clear obj
end
