from pyramid.httpexceptions import HTTPFound
import circles_backend.circles_generator as cgen
import circles_backend.circles_interface as cint

def pretty_timetable(times):
    days = len(times)
    slots = len(times[0])

    table = []
    row = []

    for d in xrange(5):
        row.append(cint.DAYS[d])
    table.append(row)

    first, last = None, None
    for t in xrange(slots):
        subjects = [times[x][t] for x in xrange(5)]
        if any(subjects):
            if first is None:
                first = t
            last = t
        else:
            continue

    for t in xrange(first, last+1):
        row = []
        row.append(t)
        for d in xrange(5):
            row.append(str(times[d][t] or '-'))
        table.append(row)

    return table

def magics(request):
    courses = request.POST['courses'].upper().split()
    if not courses:
        return {'error': 'You need to provide at least one course'}
    try:
        tables = cint.process(courses, 'free')
    except ValueError, e:
        return {'error': e, 'query': ' '.join(courses)}

    data = []
    for table in tables[:20]:
        timetable = pretty_timetable(table)
        data.append(timetable)

    return { 'courses': data, 'num': len(tables), 'query': ' '.join(courses) }

def Main(request):
    if request.method.upper() == 'POST':
        return magics(request)
    return {}

def Admin(request):
    return HTTPFound(location='http://www.youtube.com/watch?v=oHg5SJYRHA0')
