# 服务器名称长度
global.serverNameLength = 3
# 请求ID长度
global.reqIDLength = 5
# 服务器ID（自增长，起始值：1
global._serverID = 0
# 请求ID（自增长，起始值：1
global._reqID = 0

# 总权重
global.totalWeight = 0
# Server Pool
global.serverPool = []

sleep = (ms) -> new Promise (resolve) -> setTimeout resolve, ms

formatReqID = (id) ->
	str = id.toString()
	str = '0' + str for n in [...new Array(reqIDLength - str.length).keys()]
	str

class global.Server
	constructor: (@id, @defaultWeight) ->
		# 当前服务器当前并发量
		@count = 0
		# 权重
		@weight = @defaultWeight
		#console.log @weight
		# 服务器名称
		name = @id.toString()
		name = '0' + name for n in [...new Array(serverNameLength - name.length).keys()]
		@name = name
		#console.log "Server: #{ @name }	默认权重: #{ @defaultWeight }"
	execute: ->
		# 计算所有服务器的权重
		@_calcWeights()
		# 并发量 +1
		++@count
		console.log "Req: #{ formatReqID(_reqID) }  Server: #{ @name }  Default Weight: #{ @defaultWeight }	Current Weight: #{ @weight }"
		# 模拟执行过程消耗的时间（20 ~ 200ms
		ms = 20 + Math.floor Math.random() * 180
		await sleep ms
		# 并发量 -1
		--@count
		#console.log 'finished'
	## 内部函数
	# 计算所有服务器的权重
	_calcWeights: =>
		# 当前服务器权重 - 总权重
		@weight -= totalWeight
		# serverPool 中的每个服务器 + 自身默认权重
		serverPool.forEach (server) => server.weight += server.defaultWeight

# 追加服务器（动态）
global.addServer = (server) ->
	# 待追加服务器默认权重
	defaultWeight = server.defaultWeight
	# 计算总权重
	totalWeight += defaultWeight
	# add the server into serverPool
	serverPool.push server
	console.log "Add Server: #{ server.name }  Default Weight: #{ server.defaultWeight }"

# 移除服务器（动态）
global.removeServer = (server) ->
	i = serverPool.findIndex (item) => item is server
	throw new Error 'Not find server in serverPool.' if i is -1
	# 待移除服务器默认权重
	defaultWeight = server.defaultWeight
	# 计算总权重
	totalWeight -= defaultWeight
	# remove the server from serverPool
	serverPool.splice i, 1
	console.log "Remove Server: #{ server.name }"
	# TODO 

# 选择服务器
global.chooseServer = ->
	# 当前最高权重值
	maxWeight = 0
	# 用来暂存权重最高的服务器实例
	tempBox1 = []
	# 对比服务器当前权重
	for server in serverPool
		weight = server.weight
		continue if weight < maxWeight
		if weight > maxWeight
			maxWeight = weight
			tempBox1 = []
		tempBox1.push server
	return tempBox1[0] if tempBox1.length is 1
	# 最低服务器压力率
	minRate = 100
	# 用来暂存服务器压力率最低的服务器实例
	tempBox2 = []
	# 对比服务器压力率
	for server in tempBox1
		rate = server.count / server.defaultWeight
		continue if rate > minRate
		if rage < minRate
			minRate = rage
			tempBox2 = []
		tempBox2.push server
	return tempBox2[0] if tempBox2.length is 1
	# 随机获取服务器
	i = Math.floor Math.random() * tempBox2.length
	tempBox2[i]

# 接收请求总入口
global.execute = ->
	++_reqID
	server = chooseServer()
	server.execute()

######### TEST CODE #########

## 默认创建 2 个服务器
#console.group '创建默认服务器'
#for n in [...new Array(2).keys()]
#	#defaultWeight = 1 + Math.floor Math.random() * 9
#	defaultWeight = (n + 1) * 2
#	addServer new Server ++_serverID, defaultWeight
#console.groupEnd()
#
## 请求测试
#console.group '请求开始'
#execute() for n in [...new Array(12).keys()]
#console.groupEnd()

#say = (text) ->
#	console.log text
#
#countdown = (seconds) ->
#	for i in [seconds..1]
#		say i
#		await sleep 1000 # wait one second
#	say "Blastoff!"
#
##countdown 3

