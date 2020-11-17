require 'mocha'
require('chai').should()
require './main'

# 重置函数
reset = ->
	console.log 'run reset'
	global._serverID = 0
	global._reqID = 0
	global.totalWeight = 0
	global.serverPool = []
	global.logs = []

# describe '测试: 服务器指定权重（非动态）', ->
# 	before reset
# 	sc = 5	# 服务器个数
# 	tw = 0
# 	it "服务器个数符合预期: #{ sc }", ->
# 		for n in [...new Array(sc).keys()]
# 			defaultWeight = ++_serverID * 2
# 			tw += defaultWeight
# 			addServer new Server _serverID, defaultWeight
# 		serverPool.length.should.equal sc
# 	it "总权重符合预期: #{ tw }", ->
# 		totalWeight.should.equal tw
# 	describe '请求测试（非动态）', ->
# 		it '权重验证', ->
# 			rc = 80	# 请求数
# 			for i in [...new Array(rc).keys()]
# 				execute()
# 				t = 0
# 				# 每次处理请求时，验证每个服务器权重是否正常
# 				for server in serverPool
# 					w = server.weight
# 					# 当前服务器权重必须不能 < -总权重
# 					w.should.be.not.below -totalWeight
# 					# 当前服务器权重必须不能 > 总权重
# 					w.should.be.above -totalWeight
# 					t += w
# 				# 所有服务器当前权重之和等于总默认权重
# 				t.should.equal totalWeight
# 			# 在日志中随机找几个靠前位置的数据，与对应的总权重倍数位置的数据做对比：
# 			# 服务器是否为同一个、权重是否一致
# 			# 这里验证的是命中服务器的一个节奏性
# 			# 注：其实这里应该是用最小公倍数，懒得写获取最小公倍数的函数了，反正没有啥影响。。
# 			for n in [...new Array(3).keys()]
# 				i = Math.floor Math.random() * 10
# 				ii = i + totalWeight
# 				a = logs[i]
# 				b = logs[ii]
# 				nameA = a.match(/.*Server:\s*(\b\d+\b)/)[1]
# 				nameB = b.match(/.*Server:\s*(\b\d+\b)/)[1]
# 				nameA.should.equal nameB
# 				currA = a.match(/.*Current:\s*([-]?\b\d+\b)/)[1]
# 				currB = b.match(/.*Current:\s*([-]?\b\d+\b)/)[1]
# 				currA.should.equal currB
describe '测试: 服务器指定权重（动态）', ->
	before reset
	sc = 3	# 服务器个数
	tw = 0
	it "服务器个数符合预期: #{ sc }", ->
		for n in [...new Array(sc).keys()]
			defaultWeight = ++_serverID * 2
			tw += defaultWeight
			addServer new Server _serverID, defaultWeight
		serverPool.length.should.equal sc
	it "总权重符合预期: #{ tw }", ->
		totalWeight.should.equal tw
	describe '请求测试（动态）', ->
		rc = 60	# 请求数
		it '权重验证', ->
			for i in [...new Array(rc).keys()]
				# 在指定几个时间点插入新增服务器
				if i in [3, 17, 33, 49]
					defaultWeight = ++_serverID * 2
					tw += defaultWeight
					++sc
					addServer new Server _serverID, defaultWeight
				serverPool.length.should.equal sc
				### 移除服务器的逻辑暂不考虑
				# 在指定几个时间点随机移除现有服务器
				if i in [5, 21, 37, 53]
					ri = Math.floor Math.random() * serverPool.length
					server = serverPool[ri]
					console.log ri, server
					defaultWeight = server.defaultWeight
					tw -= defaultWeight
					--sc
					removeServer server
				serverPool.length.should.equal sc
				###
				execute()
				t = 0
				# 每次处理请求时，验证每个服务器权重是否正常
				for server in serverPool
					w = server.weight
					# 当前服务器权重必须不能 < -总权重
					w.should.be.not.below -totalWeight
					# 当前服务器权重必须不能 > 总权重
					w.should.be.above -totalWeight
					t += w
				# 所有服务器当前权重之和等于总默认权重
				t.should.equal totalWeight
# describe '测试: 服务器随机权重（动态）', ->
# 	before reset
# 	sc = 3	# 服务器个数
# 	tw = 0
# 	# 随机权重：1 ~ 6
# 	getRandomWeight = -> 1 + Math.floor Math.random() * 5
# 	it "服务器个数符合预期: #{ sc }", ->
# 		for n in [...new Array(sc).keys()]
# 			defaultWeight = getRandomWeight()
# 			tw += defaultWeight
# 			addServer new Server ++_serverID, defaultWeight
# 		serverPool.length.should.equal sc
# 	it "总权重符合预期: #{ tw }", ->
# 		totalWeight.should.equal tw
# 	describe '请求测试（动态）', ->
# 		rc = 120	# 请求数
# 		it '权重验证', ->
# 			# 下标在前 30 随机 5 个时间点插入新增服务器
# 			iArr = []
# 			for i in [...new Array(5).keys()]
# 				iArr.push Math.floor Math.random() * 30
# 			for i in [...new Array(rc).keys()]
# 				# 在随机5个时间点插入新增服务器
# 				if i in iArr
# 					defaultWeight = getRandomWeight()
# 					tw += defaultWeight
# 					++sc
# 					addServer new Server ++_serverID, defaultWeight
# 				serverPool.length.should.equal sc
# 				execute()
# 				t = 0
# 				# 每次处理请求时，验证每个服务器权重是否正常
# 				for server in serverPool
# 					w = server.weight
# 					# 当前服务器权重必须不能 < -总权重
# 					w.should.be.not.below -totalWeight
# 					# 当前服务器权重必须不能 > 总权重
# 					w.should.be.above -totalWeight
# 					t += w
# 				# 所有服务器当前权重之和等于总默认权重
# 				t.should.equal totalWeight
# 			# 在日志中下标 30 后，随机找几个靠前位置的数据，与对应的总权重倍数位置的数据做对比：
# 			# 服务器是否为同一个、权重是否一致
# 			# 这里验证的是命中服务器的一个节奏性
# 			# （但感觉。。这个验证好像没什么卵用。。？？，当不是同一台服务器的时，当前权重肯定是相同的，只不过被选中的服务器当前压力更小
# 			# 但因为我在选择服务器的函数中加了一段“当权重相同时，获取压力率最低的服务器”的逻辑后，当权重随机分配时，这里就只能验证命中率是否比较高
# 			# 注：其实这里应该是用最小公倍数，懒得写获取最小公倍数的函数了，反正没有啥影响。。
# 			testCount = 20
# 			temp = true: 0, false: 0
# 			for n in [...new Array(testCount).keys()]
# 				i = 30 + Math.floor Math.random() * 20
# 				ii = i + totalWeight
# 				a = logs[i]
# 				b = logs[ii]
# 				nameA = a.match(/.*Server:\s*(\b\d+\b)/)[1]
# 				nameB = b.match(/.*Server:\s*(\b\d+\b)/)[1]
# 				currA = a.match(/.*Current:\s*([-]?\b\d+\b)/)[1]
# 				currB = b.match(/.*Current:\s*([-]?\b\d+\b)/)[1]
# 				console.log nameA, nameB, currA, currB
# 				++temp[nameA is nameB and currA is currB]
# 			# 节奏命中率
# 			rate = temp[true] / testCount
# 			console.log rate
# 			rate.should.be.above 0.8
