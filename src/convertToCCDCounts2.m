function [out scale_factor] = convertToCCDCounts2(photon_map,energy)
%These values come from Song et al "Multiple application X-ray imaging chamber for
%single-shot diffraction experiments with femtosecond X-ray laser pulses"
%DOI: 10.1107/S1600576713029944
gain = 18; % electrons per ADU
system_noise = 0.15;
% system_noise = 0;

readout_noise = 250; % electrons
% readout_noise = 0; % electrons

energy_ratio = 3.65/energy; % energy is in eV
%QE = 0.8; % quantum efficiency
QE = 0.45; % from e2v paper ?CCD QE in the Soft X-Ray Range,? 2017. http://oro.open.ac.uk/49003/
scale_factor =  QE./gain./energy_ratio;
photon_map = photon_map + randn(size(photon_map)) * system_noise; %system noise is quoted in photons (it's really tiny anyway)
out = photon_map * scale_factor; % convert to counts
out(out < 0) = 0; %set negative counts to 0
out = poissrnd(out); % poisson noise affects counting statistics
out = out  + randn(size(out)) * readout_noise/gain; % gaussian detector readout noise