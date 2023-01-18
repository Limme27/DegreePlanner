def getProgram(db,code):
  cur = db.cursor()
  qry = '''
    select p.code, p.name, p.uoc, p.duration, o.longname from Programs p 
    	join OrgUnits o on p.offeredby = o.id
    	where p.code = %s
  '''
  cur.execute(qry,[code])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info

def getStream(db,code):
  cur = db.cursor()
  qry = '''
    select s.code, s.name, o.longname from Streams s 
    	join OrgUnits o on s.offeredby = o.id
    	where s.code = %s
  '''
  cur.execute(qry,[code])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info

def getStudent(db,zid):
  cur = db.cursor()
  qry = """
  select p.id, family, given
  from   People p
         join Students s on s.id = p.id
  where  p.id = %s
  """
  cur.execute(qry,[zid])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info

