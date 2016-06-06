classdef WM < handle
    %WM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        max_size
        modules
        next_index
    end
    
    methods
        
        function wm = WM()
           wm.max_size = 100; 
           wm.modules = cell(1, wm.max_size);
           wm.next_index = 1;
        end
        
        function init(wm)
            WM_funcs(1);
            wm.modules = cell(1, wm.max_size);
            wm.next_index = 1;
        end
        
        function index = NewWMModule(wm, wm_size, state_size, chunk_size)
            index = -1;
            if wm.next_index > wm.max_size
                return;
            end
            
            wm_size = wm_size(1);
            state_size = state_size(1);
            chunk_size = chunk_size(1);
            ii = WM_funcs(2, wm_size, state_size, chunk_size);
            
            if ii < 0
                return;
            end
            
            index = wm.next_index;
            
            module.mex_index = ii;
            module.index = index;
            module.state_size = state_size;
            module.chunk_size = chunk_size;
            
            
            
            wm.modules{index} = module;
            
            wm.next_index = index + 1;
        end
        
        function res = SetState(wm, index, state)
            module = wm.modules{index};
            i = module.mex_index;
            
            state = state(1:module.state_size);
            
            res = WM_funcs(4, i, state);
        end
        
        function SetReward(wm, index, value)
            module = wm.modules{index};
            i = module.mex_index;
            
            value = value(1);
            
            WM_funcs(5, i, value);
        end
        
        function res = SetExplorationPercentage(wm, index, percentage)
            module = wm.modules{index};
            
            percentage = max(0, min(percentage, 1));
            
            WM_funcs(10, module.mex_index, percentage);
            res = true;
        end
        
        function retained_chunks = Update(wm, index, state, candidate_chunks, reward)
            module = wm.modules{index};
            i = module.mex_index;
            
            candidate_chunks = candidate_chunks(:, 1:module.chunk_size);
            
            wm.SetState(index, state);
            wm.SetReward(index, reward);
            
            for jj = 1:size(candidate_chunks,1)
                cc = candidate_chunks(jj,:);
                WM_funcs(3, i, cc);
            end
            
            WM_funcs(6, module.mex_index);
            
            retained_chunks = wm.GetRetainedChunks(index);
        end
        
        function chunks = GetRetainedChunks(wm, index)
            module = wm.modules{index};
            i = module.mex_index;
            
            n = WM_funcs(7, i);
            
            chunks = zeros(n, module.chunk_size);
            
            for jj = 1:n
                chunks(jj,:) = WM_funcs(8, i, jj-1);
            end
        end
        
        function err = GetTDError(wm, index)
        	module = wm.modules{index};
            i = module.mex_index;
            
            err = WM_funcs(9, i);
        end
    end
    
end

