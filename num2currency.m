%% num2currency.m
% Translate string of numbers or numeric into string of words (currency)
% Author : Jarod Law Ding Yong
% Date : 12/12/2010
% MIT License
function words = num2currency(num)

th = {'', 'thousand', 'million', 'billion', 'trillion'};
dg = {'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'};
tn = {'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'};
tw = {'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'};

if (isnumeric(num))
   num = num2str(num);
end

if (~ischar(num))
   words = 'Invalid_Input';
   return;
end

num = regexprep(num, '[\, ]', '');

[row realLen] = size(num);

dot = strfind(num, '.');

[row len] = size(dot);

if (len == 0)
    len = realLen;
elseif (dot > 15)
    words = 'Input_value_too_large';
    return;
else
    len = dot(:,1)-1;
end

str = '';
sk = false;

% Loop Iterator
i = 1;

while (i <= len)

    if (mod(len-i+1, 3) == 2)
        if (num(i) == '1')
            str = strcat(str, tn{str2num(num(i+1)) + 1}, '_');
            sk = true;
            i = i + 1;
        elseif (num(i) ~= '0')
            str = strcat(str, tw{str2num(num(i)) - 1}, '_');
            sk = true;
        end
    elseif (num(i) ~= '0')
        str = strcat(str, dg{str2num(num(i))+1}, '_');
        if (mod(len-i+1, 3) == 0)
            str = strcat(str, 'hundred_');
        end
        sk = true;
    end
        
    if (mod(len-i+1, 3) == 1)
        if (sk)
            str = strcat(str, th{((len - i)/3) + 1}, '_');
            sk = false;
        end
    end
    
    i = i + 1;
end

if (len ~= realLen)

    i = dot(:,1)+1;
       
    if (~(num(i) == '0' && num(i+1) == '0'))
        
        str = strcat(str, 'and_');

        if (num(i) == '0')
            str = strcat(str, dg{str2num(num(i+1)) + 1}, '_');
        elseif (num(i) == '1')
            str = strcat(str, tn{str2num(num(i+1)) + 1}, '_');
        else
            str = strcat(str, tw{str2num(num(i+1)) + 1}, '_', dg{str2num(num(i+2))+1}, '_');
        end
        
    end
end

str = strcat(str, 'only');

words = regexprep(str, '_+', ' ');

