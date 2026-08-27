function MATLAB_FILTER_DESIGN_STRESS_TESTS()
% Exercise every supported filter design before it reaches the recurrence.

cfg = SignalConfig();
sampleTime = (0:0.01:1)';
for Func = 0:3
    for Type = 0:1
        testConfig = cfg;
        testConfig.testFilterFunction = Func;
        testConfig.testFilterType = Type;
        [~, ~, f_lim, A_lim] = MakeTestFile(sampleTime, testConfig);
        logPath = [tempname '.txt'];
        try
            [N, w_c, Eps] = DesignParam(Func, Type, f_lim, A_lim, ...
                cfg.filterOrderMax, cfg.alpha, logPath);
        catch exception
            assert(strcmp(exception.identifier, 'SignalProcessing:FilterOrderExceeded'), ...
                'Default design should only fail because of the configured order limit.');
            assert(ReadFilterStatus(logPath) == 2, ...
                'An over-limit design should persist an alarm status.');
            delete(logPath);
            continue;
        end;
        sections = CalculateFilterSections(Func, Type, N, cfg.alpha, w_c, Eps);

        sectionOrder = 2 + 2 * (Func > 1);
        response = [zeros(sectionOrder, 1); 1; zeros(999, 1)];
        for sectionIndex = 1:length(sections)
            section = sections{sectionIndex};
            ValidateFilterStability(section, sectionOrder);
            response = ApplyDifferenceEquation(section(1, :), section(2, :), ...
                response, zeros(size(response)), sectionOrder);
        end;
        assert(all(isfinite(response)), 'Filter impulse response must be finite.');
        assert(max(abs(response)) < 1e6, 'Filter impulse response is not bounded.');
        if exist(logPath, 'file')
            delete(logPath);
        end;
    end;
end;
end