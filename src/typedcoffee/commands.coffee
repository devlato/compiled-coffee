module.exports =
	cs2ts: (files) -> """
		$(CS2TS) -cma -o build/cs2ts #{files}
		rm #{files}
	"""

	merge: (files) ->