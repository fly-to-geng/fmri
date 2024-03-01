% 让Matlab发出声音的代码
sp=actxserver('SAPI.SpVoice');
sp.Speak('第一个被试处理完了！')