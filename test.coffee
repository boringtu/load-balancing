require 'mocha'
should = require('chai').should()
require './main'

# 重置函数
reset = ->
	_serverID = 0
	_reqID = 0
	totalWeight = 0
	serverPool = []

describe '测试: 服务器指定权重', ->
	before reset
	sc = 5	# 服务器个数
	tw = 0
	for n in [...new Array(sc).keys()]
		#defaultWeight = 1 + Math.floor Math.random() * 9
		defaultWeight = (n + 1) * 2
		tw += defaultWeight
		addServer new Server ++_serverID, defaultWeight
	it "服务器个数符合预期: #{ sc }", ->
		serverPool.length.should.equal sc
	it "总权重符合预期: #{ totalWeight }", ->
		global.totalWeight.should.equal tw
	describe '请求测试', ->
		it '权重验证', ->
			rc = 80	# 请求数
			for i in [...new Array(rc).keys()]
				execute()
				t = 0
				for server in serverPool
					w = server.weight
					# 当前服务器权重必须不能 < -总权重
					w.should.be.not.below -totalWeight
					# 当前服务器权重必须不能 > 总权重
					w.should.be.above -totalWeight
					t += w
				t.should.equal totalWeight

