[#if (ctx.getParameter("detail")?has_content)]
    [#assign tour = cmsfn.contentById(ctx.getParameter("detail"), "tours")]
    ${jsonfn.from(tour).addAll().expand('destination', 'category').expand('image', 'dam').print()}
[#else]
    [#assign tours = cmsfn.contentByPath("/magnolia-travels","tours")]
    ${ jsonfn.fromChildNodesOf(tours).addAll().print() }
[/#if]
